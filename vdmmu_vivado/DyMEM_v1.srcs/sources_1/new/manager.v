`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:31:46 PM
// Design Name: 
// Module Name: manager
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


module manager #(
        parameter TEST_EN               = 0,
        parameter TRANSLATORS           = 8,                            // Number of Translators available in the mapper.
        parameter HEAP_SIZE             = 32,                           // Total number of available 18Kb BRAM Units.
        parameter HEAP_W                = $clog2(HEAP_SIZE),
        parameter DATA_W                = 16,                           // 18x1K config.
        parameter ADDR_W                = 10,                           // 18x1K config.
        parameter UNIT_BYTES            = (DATA_W/8)*(2**ADDR_W),       // Number of Bytes a unit in heap can hold for a given config of DATA_W and ADDR_W.
        parameter REQ_W                 = $clog2(UNIT_BYTES*HEAP_SIZE),
        parameter TRANS_W               = $clog2(TRANSLATORS)
    )(
        input wire                              clk,
        input wire                              reset_n,
        // From PS
        input wire                              req_valid,              // 1 = valid request, 0 = invalid request
        input wire                              req_type,               // 0 = alloc, 1 = dealloc
        input wire  [REQ_W-1:0]                 req_bytes,              // Size of the request in bytes
        input wire  [TRANS_W-1:0]               req_trans,              // The translator ID for this request
        
        // To PS
        //output wire [HEAP_W-1:0]                rep_addr,              // Virtual Base address. Not used by PS, but the Translator will use this base_addr (HEAP_W) + offset (ADDR_W) [from PS], to access BRAM elems
        output wire [TRANS_W-1:0]               rep_trans,
        output wire                             rep_ack,
        output wire                             heap_full,              // Indicates the heap is full.
        // To Mapper
        output wire [HEAP_W*HEAP_SIZE-1:0]      vtp_map_out,
        output wire [HEAP_W*TRANSLATORS-1:0]    vtp_map_base,           // Virtual base address, used to locate the physical address (vtp_map_base + virt_offset_addr) in VTP_MAP.
        output wire [HEAP_W*TRANSLATORS-1:0]    trans_alloc_size_out,         // Maximum allocated (accessible) size for each translator port in the mapper.
        output wire [TRANSLATORS-1:0]           trans_active_out
    );
    
    localparam UNIT_W                       = $clog2(UNIT_BYTES);
    localparam DIV_OFFSET                   = 2**(UNIT_W-1);
    localparam VMAP_WR_MASK                 = { HEAP_SIZE{1'b1} };
    
    localparam S_IDLE                       = 0;
    localparam S_ALLOC                      = 1;
    localparam S_DEALLOC                    = 2;
    localparam S_DEST_GEN                   = 3;
    localparam S_VMAP_ALLOC                 = 4;
    localparam S_VMAP_DEALLOC               = 5;
    localparam S_RESERVED                   = 6;
    
    localparam STATE_W                      = $clog2(S_RESERVED);
    
    wire    [HEAP_W*HEAP_SIZE-1:0]          vtp_map_drv;
    wire    [HEAP_SIZE-1:0]                 vtp_status_drv;
    wire    [HEAP_W-1:0]                    i_trans_base_val;
    wire    [HEAP_W:0]                      i_trans_alloc_val;
    wire                                    i_trans_active_val;
    wire    [HEAP_W*HEAP_SIZE-1:0]          full_list_dest_drv;
    wire    [HEAP_W*HEAP_SIZE-1:0]          free_list_dest_drv;
    wire    [HEAP_SIZE-1:0]                 full_list_valid_drv;
    wire    [HEAP_SIZE-1:0]                 free_list_valid_drv;
    
    wire    [HEAP_SIZE-1:0]                 man_wr_mask_0_alloc;
    wire    [HEAP_SIZE-1:0]                 man_wr_mask_1_alloc;
    wire    [HEAP_SIZE-1:0]                 man_wr_mask_0_dealloc;
    wire    [HEAP_SIZE-1:0]                 man_wr_mask_1_dealloc;
    
    wire    [REQ_W:0]                       i_avail_bytes;
    wire    [HEAP_W:0]                      i_alloc_units;
    
    (* MARK_DEBUG = "TRUE" *)reg     [REQ_W:0]                       avail_bytes;
    (* MARK_DEBUG = "TRUE" *)reg     [HEAP_W:0]                      alloc_units;
    //reg     [HEAP_SIZE-1:0]                 man_wr_mask_0_alloc;
    //reg     [HEAP_SIZE-1:0]                 man_wr_mask_1_alloc;
    //reg     [HEAP_SIZE-1:0]                 man_wr_mask_0_dealloc;
    //reg     [HEAP_SIZE-1:0]                 man_wr_mask_1_dealloc;
    reg     [HEAP_W-1:0]                    trans_vtp_base_drv[0:TRANSLATORS-1];
    reg     [HEAP_W:0]                      trans_alloc_size_drv[0:TRANSLATORS-1];
    (* MARK_DEBUG = "TRUE" *)reg     [HEAP_W-1:0]                    trans_vtp_base[0:TRANSLATORS-1];
    (* MARK_DEBUG = "TRUE" *)reg     [HEAP_W:0]                      trans_alloc_size[0:TRANSLATORS-1];
    (* MARK_DEBUG = "TRUE" *)reg     [TRANSLATORS-1:0]               trans_active;
    (* MARK_DEBUG = "TRUE" *)reg     [HEAP_W:0]                      free_ptr;
    reg     [STATE_W-1:0]                   cur_state;
    reg                                     r_rep_ack;
    reg     [TRANS_W-1:0]                   r_rep_trans;
    //reg     [HEAP_W-1:0]                    r_rep_addr;
    
    reg     [STATE_W-1:0]                   next_state;
    reg     [HEAP_W:0]                      free_ptr_drv;
    reg                                     trans_active_drv;
    reg                                     i_trans_valid;
    reg                                     rep_ack_drv;
    reg                                     vmap_gen_en_drv;
    reg                                     dest_gen_en_drv;
    reg     [HEAP_SIZE-1:0]                 man_wr_mask_drv;
    reg                                     man_wr_status_drv;
    
    genvar i;
    integer k;
    
    assign i_avail_bytes = (HEAP_SIZE-free_ptr) << UNIT_W;
    assign i_alloc_units = (req_bytes+DIV_OFFSET) >> UNIT_W;
    //assign round_alloc_units = i_alloc_units & 1'b1;
    
    assign i_trans_base_val = trans_vtp_base[req_trans];
    assign i_trans_alloc_val = trans_alloc_size[req_trans];
    assign i_trans_active_val = trans_active[req_trans];
    
    assign man_wr_mask_0_alloc = VMAP_WR_MASK << free_ptr;
    assign man_wr_mask_1_alloc = VMAP_WR_MASK >> (HEAP_SIZE-free_ptr-i_trans_alloc_val);
    assign man_wr_mask_0_dealloc = VMAP_WR_MASK << i_trans_base_val;
    assign man_wr_mask_1_dealloc = VMAP_WR_MASK >> (HEAP_SIZE-i_trans_base_val-i_trans_alloc_val);
    
    assign vtp_map_out = vtp_map_drv;
    //assign rep_ack = rep_ack_drv;
    assign rep_ack = r_rep_ack;
    assign rep_trans = r_rep_trans;
    //assign rep_addr = r_rep_addr;
    assign trans_active_out = trans_active;
    assign heap_full = (free_ptr == HEAP_SIZE) ? 1'b1 : 1'b0;
    
    generate
        for (i = 0; i < TRANSLATORS; i = i+1) begin
            assign vtp_map_base[i*HEAP_W +: HEAP_W] = trans_vtp_base[i];
            assign trans_alloc_size_out[i*HEAP_W +: HEAP_W] = trans_alloc_size[i];
        end
    endgenerate
    
    vmap_gen #(
        .TEST_EN(TEST_EN),
        .HEAP_SIZE(HEAP_SIZE),
        .HEAP_W(HEAP_W)
    ) vmap_gen_i (
        .clk(clk),
        .reset_n(reset_n),
        .full_list_dest(full_list_dest_drv),
        .free_list_dest(free_list_dest_drv),
        .full_list_valid(full_list_valid_drv),
        .free_list_valid(free_list_valid_drv),
        .manager_wr_valid(man_wr_mask_drv),
        .manager_status_in(man_wr_status_drv),
        .vmap_gen_en(vmap_gen_en_drv),
        
        .vtp_map(vtp_map_drv),
        .vtp_status(vtp_status_drv)
    );
    
    dest_gen #(
        .HEAP_SIZE(HEAP_SIZE),
        .HEAP_W(HEAP_W)
    ) dest_gen_i (
        .clk(clk),
        .reset_n(reset_n),
        .free_ptr(free_ptr),
        .dealloc_base(i_trans_base_val),
        .dealloc_size(i_trans_alloc_val),
        .vtp_status_in(vtp_status_drv),
        .dest_gen_en(dest_gen_en_drv),
        
        .full_list_dest(full_list_dest_drv),
        .free_list_dest(free_list_dest_drv),
        .full_list_valid(full_list_valid_drv),
        .free_list_valid(free_list_valid_drv)
    );
    
    always @(posedge clk) begin
        if (!reset_n) begin
            cur_state <= S_IDLE;
            free_ptr <= 0;
            r_rep_ack <= 0;
            r_rep_trans <= 0;
            //r_rep_addr <= 0;
        end
        else begin
            cur_state <= #1 next_state;
            free_ptr <= #1 free_ptr_drv;
            r_rep_ack <= #1 rep_ack_drv;
            r_rep_trans <= #1 req_trans;
            //r_rep_addr <= #1 free_ptr;
        end
    end
    
    always @(*) begin
        next_state = cur_state;
        free_ptr_drv = free_ptr;
        rep_ack_drv = 1'b0;
        i_trans_valid = 1'b0;
        trans_active_drv = 1'b0;
        man_wr_mask_drv = 1'b0;
        man_wr_status_drv = 1'b0;
        vmap_gen_en_drv = 1'b0;
        dest_gen_en_drv = 1'b0;
        case (cur_state)
            S_IDLE      : begin
                if (req_valid) begin
                    if (req_type && i_trans_active_val) begin
                        next_state = S_VMAP_DEALLOC;
                    end
                    else if (!req_type && !i_trans_active_val && req_bytes <= avail_bytes) begin
                        next_state = S_ALLOC;
                    end
                end
            end
            S_ALLOC     : begin
                i_trans_valid = 1'b1;
                trans_active_drv = 1'b1;
                //rep_ack_drv = 1'b1;
                next_state = S_VMAP_ALLOC;
            end
            S_DEALLOC     : begin
                i_trans_valid = 1'b1;
                trans_active_drv = 1'b0;
                free_ptr_drv = free_ptr - i_trans_alloc_val;
                rep_ack_drv = 1'b1;
                next_state = S_RESERVED;
            end
            S_VMAP_ALLOC  : begin
                // Generate Bit masks for VMAP_GEN
                rep_ack_drv = 1'b1;
                vmap_gen_en_drv = 1'b1;
                man_wr_mask_drv = man_wr_mask_0_alloc & man_wr_mask_1_alloc;
                man_wr_status_drv = 1'b1;
                free_ptr_drv = free_ptr + i_trans_alloc_val;
                next_state = S_RESERVED;
            end
            S_VMAP_DEALLOC  : begin
                // Generate Bit masks for VMAP_GEN
                vmap_gen_en_drv = 1'b1;
                man_wr_mask_drv = man_wr_mask_0_dealloc & man_wr_mask_1_dealloc;
                man_wr_status_drv = 1'b0;
                next_state = S_DEST_GEN;
            end
            S_DEST_GEN      : begin
                dest_gen_en_drv = 1'b1;
                // Move the update of trans_registers to the next cycle 
                // to match timing with VMAP update. If done here, VMAP
                // will update end of next cycle, causing the translator 
                // port to be not ready (in the mapper) for a single cycle.
                //i_trans_valid = 1'b1;
                //trans_active_drv = 1'b0;
                //free_ptr_drv = free_ptr - i_trans_alloc_val;
                next_state = S_DEALLOC;
            end
            S_RESERVED      : begin
                // Wait for valid to go low
                rep_ack_drv = (req_valid) ? 1'b1 : 1'b0;
                next_state = (req_valid) ? cur_state : S_IDLE;
            end
        endcase
    end
        
    always @(posedge clk) begin
        avail_bytes <= #1 (reset_n) ? i_avail_bytes : 0;
        alloc_units <= #1 (reset_n) ? i_alloc_units : 0;
        // Masks
        //man_wr_mask_0_alloc <= VMAP_WR_MASK << free_ptr;
        //man_wr_mask_1_alloc <= VMAP_WR_MASK >> (HEAP_SIZE-free_ptr-i_trans_alloc_val);
        //man_wr_mask_0_dealloc <= VMAP_WR_MASK << i_trans_base_val;
        //man_wr_mask_1_dealloc <= VMAP_WR_MASK >> (HEAP_SIZE-i_trans_base_val-i_trans_alloc_val);
    end
    
    always @(posedge clk) begin
        if (!reset_n) begin
            for (k = 0; k < TRANSLATORS; k = k+1) begin
                trans_vtp_base[k] <= 0;
                trans_alloc_size[k] <= 0;
                trans_active[k] <= 1'b0;
            end
        end
        else begin
            for (k = 0; k < TRANSLATORS; k = k+1) begin
                trans_vtp_base[k] <= #1 (i_trans_valid) ? trans_vtp_base_drv[k] : trans_vtp_base[k];
                trans_alloc_size[k] <= #1 (i_trans_valid) ? trans_alloc_size_drv[k] : trans_alloc_size[k];
                trans_active[k] <= #1 (i_trans_valid && req_trans == k) ? trans_active_drv : trans_active[k];
            end
        end
    end
    
    always @(*) begin
        for (k = 0; k < TRANSLATORS; k = k+1) begin
            if (req_trans == k && !req_type) trans_vtp_base_drv[k] = free_ptr;
            else if(req_type && trans_vtp_base[k] > i_trans_base_val) trans_vtp_base_drv[k] = trans_vtp_base[k]-i_trans_alloc_val; 
            else trans_vtp_base_drv[k] = trans_vtp_base[k];
        end
    end
    
    always @(*) begin
        for (k = 0; k < TRANSLATORS; k = k+1) begin
            if (req_trans == k && !req_type) trans_alloc_size_drv[k] = alloc_units;
            else trans_alloc_size_drv[k] = trans_alloc_size[k];
        end
    end
    
endmodule
