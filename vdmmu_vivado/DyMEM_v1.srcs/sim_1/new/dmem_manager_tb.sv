`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:33:56 PM
// Design Name: 
// Module Name: dmem_manager_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dmem_manager_tb;
    
    parameter CLK_PERIOD    = 10;
    parameter INPUT_DELAY   = 1.5;
    parameter GSR_DELAY     = 100;

    parameter BUFFER_WR     = 0;
    parameter BUFFER_RD     = 1;                    // Read output regs are required if External logic is used for comms. (To meet timing).
    parameter BUFFER_TRANS  = 1;
    parameter TEST_EN       = 1;
    
    parameter MEM_PORTS     = 32;
    //parameter BENES_PORTS   = MEM_PORTS/2;
    parameter BENES_PORTS   = 8;
    parameter AP_WINDOW     = 2;
    parameter TRANSLATORS   = BENES_PORTS/AP_WINDOW;
    parameter MEM_W         = $clog2(MEM_PORTS);
    parameter OFFSET        = 11;
    parameter DATA_W        = 8;
    parameter ADDR_W        = OFFSET+MEM_W+1;
    parameter MEM_CTRL      = OFFSET+1;
    parameter UNIT_BYTES    = (DATA_W/8)*(2**OFFSET);
    parameter REQ_W         = $clog2(UNIT_BYTES*MEM_PORTS);
    parameter TRANS_W       = $clog2(TRANSLATORS);
    parameter BRAM_SIZE     = "18Kb";
    
    parameter REQ_LEN       = 8;
    parameter WRITE_WORDS   = 10;

    reg                                 clk;
    reg                                 reset_n;
    reg     [TRANS_W-1:0]               i_req_id;
    reg     [REQ_W-1:0]                 i_req_bytes;
    reg                                 i_req_type;
    reg                                 i_req_valid;
    reg     [TRANS_W-1:0]               r_req_id;
    reg     [REQ_W-1:0]                 r_req_bytes;
    reg                                 r_req_type;
    reg                                 r_req_valid;
    
    //reg     [MEM_W-1:0]                 set_window_base;
    //reg                                 set_window_manual;
    //reg                                 ap_rebase;
    reg                                 benes_restart;
    
    reg     [TRANS_W-1:0]               i_ps_trans;
    reg     [ADDR_W-2:0]                i_ps_addr;
    reg                                 i_ps_addr_valid;
    reg                                 i_ps_we;
    reg     [DATA_W-1:0]                i_ps_wr;
    reg     [ADDR_W-2:0]                i_pl_addr[0:TRANSLATORS-1];
    reg     [TRANSLATORS-1:0]           i_pl_addr_valid;
    reg     [TRANSLATORS-1:0]           i_pl_we;
    reg     [DATA_W-1:0]                i_pl_wr_data[0:TRANSLATORS-1];
    
    reg     [DATA_W-1:0]                t_data[0:WRITE_WORDS-1];
    
    wire                                ps_rd_valid;
    wire    [DATA_W-1:0]                ps_rd;
    //wire    [ADDR_W-1:0]                ps_addr;
    //wire    [TRANSLATORS-1:0]           pl_addr_valid;
    wire    [ADDR_W*TRANSLATORS-1:0]    pl_addr;
    wire    [DATA_W*TRANSLATORS-1:0]    pl_wr;
    wire    [DATA_W*TRANSLATORS-1:0]    pl_rd;
    wire    [DATA_W-1:0]                pl_rd_data[0:TRANSLATORS-1];
    wire    [TRANSLATORS-1:0]           pl_rdy;
    wire    [TRANSLATORS-1:0]           pl_rd_valid;
    
    wire    [TRANS_W-1:0]               i_rep_id;
    wire    [MEM_W-1:0]                 i_rep_addr;
    wire                                i_rep_ack;
    wire                                i_heap_full;
    
    genvar i;
    integer j, k;
    
    //                                [  Allocs  || Deallocs ]
    //integer req_id[0:REQ_LEN-1]     = {3, 0, 7, 0, 5, 3, 5, 7};
    //integer req_bytes[0:REQ_LEN-1]  = {4000, 8000, 10000, 1000, 10000, 4000, 10000, 2000};
    integer req_id[0:REQ_LEN-1]     = {3, 0, 2, 0, 1, 2, 1, 3};
    integer req_bytes[0:REQ_LEN-1]  = {4000, 8000, 10000, 1000, 10000, 4000, 10000, 2000};
    integer req_type[0:REQ_LEN-1]   = {0, 0, 0, 1, 0, 1, 1, 1};
    integer req_valid[0:REQ_LEN-1]  = {1, 1, 1, 1, 1, 1, 1, 1};
        
    generate
        for (i = 0; i < TRANSLATORS; i = i+1) begin
            assign pl_addr[i*ADDR_W +: ADDR_W] = {i_pl_we[i], i_pl_addr[i]};
            assign pl_wr[i*DATA_W +: DATA_W] = i_pl_wr_data[i];
            assign pl_rd_data[i] = pl_rd[i*DATA_W +: DATA_W];
        end
    endgenerate
    
    dmem_manager #(
        .TEST_EN(TEST_EN),
        .BUFFER_WR(BUFFER_WR),
        .BUFFER_RD(BUFFER_RD),
        .BUFFER_TRANS(BUFFER_TRANS),
        .MEM_PORTS(MEM_PORTS),
        .BENES_PORTS(BENES_PORTS),
        .AP_WINDOW(AP_WINDOW),
        .TRANSLATORS(TRANSLATORS),
        .DATA_W(DATA_W),
        .OFFSET(OFFSET),
        .MEM_W(MEM_W),
        .ADDR_W(ADDR_W),
        .MEM_CTRL(MEM_CTRL),
        .TRANS_W(TRANS_W),
        .UNIT_BYTES(UNIT_BYTES),
        .REQ_W(REQ_W),
        .BRAM_SIZE(BRAM_SIZE)
    ) dmem_manager_i (
        .clk(clk),
        .reset_n(reset_n),
        .benes_restart(benes_restart),
        //.ap_rebase(ap_rebase),
        //.set_window_manual(set_window_manual),
        //.set_window_base(set_window_base),
        // From OS (PS)
        .req_valid(i_req_valid),              // 1 = valid request, 0 = invalid request
        .req_type(i_req_type),               // 0 = alloc, 1 = dealloc
        .req_bytes(i_req_bytes),              // Size of the request in bytes
        .req_trans(i_req_id),              // The translator ID for this request
        .ps_addr_valid(i_ps_addr_valid),
        .ps_trans_id(i_ps_trans),
        .ps_addr_bus(i_ps_addr),
        .ps_wr_data_bus(i_ps_wr),
        .ps_we(i_ps_we),
        // From Master (RTL)
        .pl_addr_valid(i_pl_addr_valid),
        .pl_addr_bus(pl_addr),
        .pl_wr_data_bus(pl_wr),
        
        // To OS (PS)
        //.rep_addr(i_rep_addr),              // Virtual Base address. Not used by PS, but the Translator will use this base_addr (HEAP_W) + offset (ADDR_W) [from PS], to access BRAM elems
        .rep_trans(i_rep_id),
        .rep_ack(i_rep_ack),
        .heap_full(i_heap_full),              // Indicates the heap is full.
        
        .ps_rd_data_bus(ps_rd),
        .ps_rd_data_valid(ps_rd_valid),
        // To Master (RTL/PS)
        .pl_port_ready(pl_rdy),
        .pl_rd_data_bus(pl_rd),
        .pl_rd_data_valid(pl_rd_valid)
    );
    
    always #(CLK_PERIOD/2) clk = ~clk;
    
    always @(posedge clk) begin
        r_req_id <= (reset_n) ? i_req_id : 0;
        r_req_bytes <= (reset_n) ? i_req_bytes : 0;
        r_req_type <= (reset_n) ? i_req_type : 0;
        r_req_valid <= (reset_n) ? i_req_valid : 0;
    end
        
    initial begin
        // Init signals
        clk = 1'b1;
        reset_n = 1'b1;
        benes_restart = 1'b0;
        //set_window_manual = 1'b0;
        //set_window_base = 1'b0;
        //ap_rebase = 1'b0;
        i_req_id = 0;
        i_req_bytes = 0;
        i_req_type = 0;
        i_req_valid = 0;
        i_ps_trans = 0;
        i_ps_wr = 0;
        i_ps_addr = 1024;
        i_ps_we = 0;
        i_ps_addr_valid = 0;
        i_pl_addr_valid = 0;
        for (j = 0; j < TRANSLATORS; j = j+1) begin
            i_pl_addr[j] = 2047;
            i_pl_we[j] = 0;
            i_pl_wr_data[j] = 0;
        end
        // Skip GSR
        #(GSR_DELAY);
        #(CLK_PERIOD*2);
        // Assert reset
        reset_n = 1'b0;
        #(CLK_PERIOD*2);
        // Deassert reset
        reset_n = 1'b1;
        
        // Insert input delay to all signals
        //#(INPUT_DELAY);
        
        // Perform  3 Allocs
        for (j = 0; j < 3; j = j+1) begin
            @(posedge clk);
            #1;
            i_req_id = req_id[j];
            i_req_bytes = req_bytes[j];
            i_req_type = req_type[j];
            i_req_valid = req_valid[j];
            $display("%t ||| TB || REQUEST[%0d] -> req_ID = %0d | req_BYTES = %0d | req_TYPE = %0d | req_VALID = %0d", $time, j, i_req_id, i_req_bytes, i_req_type, i_req_valid);
            // Wait for ACK
            @(posedge clk);
            #2;
            while(!i_rep_ack) #(CLK_PERIOD);
            if (i_rep_ack) begin
                //@(posedge clk)
                //#1;
                i_req_valid = 0;
                $display("%t ||| TB || RECIEVED ACK | REP_ID = %0d | HEAP_FULL = 0%d", $time, i_rep_id, i_heap_full);
            end
        end
        i_req_valid = 0;
        // Write to PL [7] (req_id[2]) from PS
        //ps_trans = req_id[2];
        for (j = 0; j < WRITE_WORDS; j = j+1) begin
            @(posedge clk);
            #1;
            i_ps_trans = req_id[2];
            i_ps_addr_valid = 1'b1;
            i_ps_addr[OFFSET +: MEM_W] = 2;
            i_ps_addr[0 +: OFFSET] = j;
            i_ps_we = 1'b1;
            i_ps_wr = j+1;
            $display("%t ||| TB || PS || Writing [%0d] to translator [%0d] at [%0d]", $time, i_ps_wr, req_id[2], i_ps_addr);
            //@(posedge clk);
            //#1;
        end
        @(posedge clk);
        #1;
        i_ps_addr_valid = 1'b0;
        i_ps_trans = 0;
        i_ps_we = 0;
        
        //---------------------------------------------------------------
        //  PS to BRAM (any) adds a latency of 1 (the translator)
        //---------------------------------------------------------------
        
        // Read from PS
        for (j = 0; j < WRITE_WORDS; j = j+1) begin
            @(posedge clk);
            #1;
            i_ps_trans = req_id[2];
            i_ps_addr_valid = 1'b1;
            i_ps_addr[OFFSET +: MEM_W] = 2;
            i_ps_addr[0 +: OFFSET] = j;
            i_ps_we = 1'b0;
            i_ps_wr = 0;
            //@(posedge clk);
            //#1;
            if (ps_rd_valid) begin
                $display("%t ||| TB || PS || Read [%0d] at [%0d] from translator [%0d]", $time, ps_rd, i_ps_addr, req_id[2]);
            end
        end
        @(posedge clk);
        #1;
        i_ps_addr_valid = 1'b0;
        
        #(CLK_PERIOD*3);
        //$finish;
        
        // Read from PL [7]
        @(posedge clk);
        #1;
        for (j = 0; j < WRITE_WORDS; j = j+1) begin
            i_pl_addr_valid[2] = 1'b1;
            i_pl_addr[2][OFFSET +: MEM_W] = 2;
            i_pl_addr[2][0 +: OFFSET] = j;
            i_pl_we[2] = 0;
            @(posedge clk);
            #2;
            while (!pl_rdy[2]) #(CLK_PERIOD);
            if (pl_rdy[2] && pl_rd_valid[2]) begin
                $display("%t ||| TB || PL[%0d] | Read [%0d] from [%0d]", $time, 2, pl_rd_data[2], j);
            end
        end
        i_pl_addr_valid[2] = 1'b0;
        //--------------------------------------------------------------
        //  PL to BRAM (same) -> 1 cycle latency due to translator
        //  PL to BRAM (diff) -> 3 cycle latency due to Benes + translator
        //  Note: the port_ready signal from the translator should be registered
        //        on the negedge, becuase the HLS stream converter will be used 
        //        as a skid buffer. Therefore it requires the current ready signal
        //        on the posedge.
        //--------------------------------------------------------------
        
        #(CLK_PERIOD*3);
        //$finish;
        
        // Dealloc middle trans
        @(posedge clk);
        #1;
        i_req_id = req_id[1];
        i_req_bytes = 0;
        i_req_type = 1'b1;
        i_req_valid = 1'b1;
        // Wait for ack
        @(posedge clk);
        #3;
        while(!i_rep_ack) #(CLK_PERIOD);
        if (i_rep_ack) begin
            i_req_valid = 1'b0;
            $display("%t ||| TB || RECIEVED ACK | REP_ID = %0d | HEAP_FULL = 0%d", $time, i_rep_id, i_heap_full);
        end
        // Write from PL[2]
        @(posedge clk);
        #1;
        for (j = 0; j < WRITE_WORDS; j = j+1) begin
            i_pl_addr_valid[2] = 1'b1;
            i_pl_addr[2][0 +: OFFSET] = j;
            i_pl_addr[2][OFFSET +: MEM_W] = 3;
            i_pl_we[2] = 1'b1;
            i_pl_wr_data[2] = j+11;
            @(posedge clk);
            #2;
            while (!pl_rdy[2]) #(CLK_PERIOD);
            $display("%t ||| TB || PL[%0d] || Writing [%0d] at [%0d]", $time, 7, i_pl_wr_data[2], i_pl_addr[2]);
        end
        i_pl_addr_valid[7] = 1'b0;
        i_pl_we[7] = 0;
        #(CLK_PERIOD);
        @(posedge clk);
        // Read from PS
        /*
        ps_trans = req_id[2];
        for (j = 0; j < WRITE_WORDS; j = j+1) begin
            i_ps_addr_valid = 1'b1;
            i_ps_addr = j;
            ps_we = 1'b0;
            ps_wr = 0;
            @(posedge clk);
            #1;
            if (ps_rd_valid) begin
                $display("%t ||| TB || PS || Read [%0d] at [%0d] from translator [%0d]", $time, ps_rd, i_ps_addr, req_id[2]);
            end
        end
        i_ps_addr_valid = 1'b0;
        */
        #(CLK_PERIOD*4);
        $finish;
    end

endmodule
