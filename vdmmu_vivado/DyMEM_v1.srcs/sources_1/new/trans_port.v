`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:17:32 PM
// Design Name: 
// Module Name: trans_port
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


module trans_port #(
        parameter BUFFER_TRANS  = 1,
        parameter MEM_PORTS     = 32,
        parameter DATA_W        = 32,
        parameter OFFSET        = 9,
        parameter MEM_W         = $clog2(MEM_PORTS),
        parameter ADDR_W        = OFFSET+MEM_W+1,            // +1 for rd,wr en
        parameter MEM_CTRL      = OFFSET+1,
        parameter BENES_PORTS   = MEM_PORTS/2,
        parameter WINDOW_W      = 2
    )(
        input wire                          clk,
        input wire                          reset_n,
        // Control signals
        //input wire                          ap_rebase,
        input wire                          benes_restart,
        input wire                          benes_batch_start,
        //input wire                          manual,
        //input wire  [MEM_W-1:0]             window_base,
        // From proc
        input wire                          pl_addr_valid,
        input wire  [ADDR_W-1:0]            pl_addr,
        input wire  [DATA_W-1:0]            pl_wr_data,
        // From memory
        input wire  [DATA_W*WINDOW_W-1:0]   mem_rd_data,
        // From Allocator (unicast)
        input wire  [MEM_W-1:0]             trans_base_addr,
        input wire  [MEM_W-1:0]             trans_max_addr,
        input wire                          trans_active,
        // Broadcasted to all translators
        input wire  [MEM_W*MEM_PORTS-1:0]   vtp_map,
        
        // To proc
        output wire                         trans_port_ready,
        output wire [DATA_W-1:0]            pl_rd_data,
        // To Benes
        output wire [MEM_W*WINDOW_W-1:0]    phy_map_addr,
        output wire [WINDOW_W-1:0]          phy_map_valid,
        // To memory
        output wire [MEM_CTRL*WINDOW_W-1:0] mem_pl_ctrl,
        output wire [DATA_W*WINDOW_W-1:0]   mem_wr_data
    );
        
    wire    [DATA_W-1:0]                i_mem_rd_data_unpkd[0:WINDOW_W-1];
    wire    [DATA_W-1:0]                o_mem_rd_data_unpkd[0:WINDOW_W-1];
    wire    [MEM_W-1:0]                 phy_map_addr_unpkd[0:WINDOW_W-1];
    wire    [MEM_CTRL-1:0]              mem_pl_ctrl_unpkd[0:WINDOW_W-1];
    wire    [DATA_W-1:0]                mem_wr_data_unpkd[0:WINDOW_W-1];
        
    wire    [WINDOW_W-1:0]              ap_port_ready;
    //wire    [WINDOW_W-1:0]              ap_mod;
    //wire    [WINDOW_W-1:0]              ap_sel;
    wire    [WINDOW_W-1:0]              ap_addr_valid;
    wire    [WINDOW_W-1:0]              ap_re_loc;
    wire                                ap_re_loc_drv;
    reg     [WINDOW_W-1:0]              ap_re_loc_sel;
    //reg     [WINDOW_W-1:0]              ap_addr_valid;
    reg                                 ap_sel;
    
    wire                                addr_we;
    wire    [MEM_W-1:0]                 addr_port;
    wire    [OFFSET-1:0]                addr_offset;
    reg     [MEM_W-1:0]                 prev_addr_port;
    
    //wire                                ap_rebase;
    //wire    [MEM_W-1:0]                 window_base;
    wire    [MEM_W-1:0]                 ap_virt_addr[0:WINDOW_W-1];
    reg     [MEM_W-1:0]                 window_base;
    reg                                 ap_rebase;
    
    genvar i;
    integer k;
    
    assign addr_offset = pl_addr[0 +: OFFSET];
    assign addr_port = pl_addr[OFFSET +: MEM_W];
    assign addr_we = pl_addr[ADDR_W-1];
    
    // Perform: addr_port % WINDOW_W
    //assign ap_mod = { WINDOW_W{1'b1} } >> 1;
    //assign ap_sel = addr_port & ap_mod;
    assign ap_addr_valid = pl_addr_valid << ap_sel;
    
    // Reloc and rebase
    assign ap_re_loc_drv = (pl_addr_valid && addr_port != prev_addr_port) ? 1'b1 : 1'b0;
    assign ap_re_loc = ap_re_loc_drv << ap_re_loc_sel;
    
    // out
    assign pl_rd_data = o_mem_rd_data_unpkd[ap_sel];
    assign trans_port_ready = ap_port_ready[ap_sel];
        
    generate
        for (i = 0; i < WINDOW_W; i = i+1) begin
            assign i_mem_rd_data_unpkd[i] = mem_rd_data[i*DATA_W +: DATA_W];
            assign phy_map_addr[i*MEM_W +: MEM_W] = phy_map_addr_unpkd[i];
            assign mem_pl_ctrl[i*MEM_CTRL +: MEM_CTRL] = mem_pl_ctrl_unpkd[i];
            assign mem_wr_data[i*DATA_W +: DATA_W] = mem_wr_data_unpkd[i];
        end
    endgenerate
    
    generate
        for (i = 0; i < WINDOW_W; i = i+1) begin
            access_port #(
                .BUFFER_TRANS(BUFFER_TRANS),
                .MEM_PORTS(MEM_PORTS),
                .DATA_W(DATA_W),
                .OFFSET(OFFSET),
                .MEM_W(MEM_W),
                .ADDR_W(ADDR_W),
                .MEM_CTRL(MEM_CTRL),
                .BENES_PORTS(BENES_PORTS),
                .WINDOW_W(WINDOW_W),
                .AP_NUM(i)
            ) ap_i (
                .clk(clk),
                .reset_n(reset_n),
                // Control
                .ap_rebase(ap_rebase),
                .benes_restart(benes_restart),
                .benes_batch_start(benes_batch_start),
                .re_loc(ap_re_loc[i]),             // Assert to relocate AP's Virtual destination
                //.manual(manual),
                .window_base(window_base),
                // From proc
                .addr_valid(ap_addr_valid[i]),
                .addr_we(addr_we),
                .addr_offset(addr_offset),
                .wr_data_bus(pl_wr_data),
                // From memory
                .mem_rd_data(i_mem_rd_data_unpkd[i]),
                // From Allocator (unicast)
                .base_addr(trans_base_addr),
                .max_addr(trans_max_addr),
                .active_in(trans_active),
                // Broadcasted to all translators
                .vtp_map(vtp_map),
                
                .cur_virt_addr(ap_virt_addr[i]),
                // To proc
                .port_ready(ap_port_ready[i]),
                .rd_data_bus(o_mem_rd_data_unpkd[i]),
                // To Benes
                .phy_map_addr(phy_map_addr_unpkd[i]),
                .phy_map_valid(phy_map_valid[i]),
                // To memory
                .mem_op_ctrl(mem_pl_ctrl_unpkd[i]),
                .mem_wr_data(mem_wr_data_unpkd[i])
            );
        end
    endgenerate
    
    always @(posedge clk) begin
        prev_addr_port <= (reset_n && pl_addr_valid) ? addr_port : 0;
        ap_re_loc_sel <= (reset_n) ? ap_sel : 0;
    end
    
    // ap_select and ap_rebase
    always @(*) begin
        ap_sel = 0;
        ap_rebase = 1'b1;
        window_base = addr_port;
        for (k = 0; k < WINDOW_W; k = k+1) begin
            if (addr_port == ap_virt_addr[k]) begin
                ap_sel = k;
                ap_rebase = 1'b0;
                window_base = 0;
            end
        end
    end
        
endmodule
