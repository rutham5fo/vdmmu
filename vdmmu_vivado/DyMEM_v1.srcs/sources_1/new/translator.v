`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:21:43 PM
// Design Name: 
// Module Name: translator
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


module translator #(
        parameter BUFFER_TRANS  = 1,
        parameter MEM_PORTS     = 32,
        parameter BENES_PORTS   = MEM_PORTS/2,
        parameter WINDOW_W      = 2,
        parameter NODES         = BENES_PORTS/WINDOW_W,
        parameter NODE_W        = $clog2(NODES),
        parameter DATA_W        = 32,
        parameter OFFSET        = 9,
        parameter MEM_W         = $clog2(MEM_PORTS),
        parameter ADDR_W        = OFFSET+MEM_W+1,            // +1 for rd,wr en
        parameter MEM_CTRL      = OFFSET+1
    )(
        input wire                              clk,
        input wire                              reset_n,
        //input wire                              ap_rebase,
        input wire                              benes_restart,
        input wire                              benes_batch_start,
        //input wire                              manual,
        //input wire  [MEM_W-1:0]                 window_base,
        input wire  [NODES-1:0]                 pl_addr_valid,
        input wire  [ADDR_W*NODES-1:0]          pl_addr,
        input wire  [DATA_W*NODES-1:0]          pl_wr_data,
        input wire  [DATA_W*BENES_PORTS-1:0]    mem_rd_data,
        input wire  [MEM_W*MEM_PORTS-1:0]       vtp_map,
        input wire  [MEM_W*NODES-1:0]           trans_base_addr,
        input wire  [MEM_W*NODES-1:0]           trans_max_addr,
        input wire  [NODES-1:0]                 trans_active,
        // PS
        input wire                              ps_addr_valid,
        input wire  [NODE_W-1:0]                ps_trans_id,
        input wire  [ADDR_W-1:0]                ps_addr_bus,
        input wire  [DATA_W-1:0]                ps_wr_data_bus,
        input wire  [DATA_W*MEM_PORTS-1:0]      mem_ps_rd_data,
        
        // PS
        output wire [DATA_W-1:0]                ps_rd_data_bus,
        output wire [DATA_W*MEM_PORTS-1:0]      mem_ps_wr_data,
        output wire [MEM_CTRL*MEM_PORTS-1:0]    mem_ps_addr,
        // Others
        output wire [DATA_W*NODES-1:0]          pl_rd_data,
        output wire [MEM_W*BENES_PORTS-1:0]     phy_map_addr,
        output wire [BENES_PORTS-1:0]           phy_map_valid,
        output wire [MEM_CTRL*BENES_PORTS-1:0]  mem_op_ctrl,
        output wire [DATA_W*BENES_PORTS-1:0]    mem_wr_data,
        output wire [NODES-1:0]                 trans_port_ready
    );
    
    localparam IO_FACTOR                = MEM_PORTS/BENES_PORTS;
    localparam IO_DIST                  = 2*IO_FACTOR;
    localparam EVEN_ODD                 = BENES_PORTS/2;
    
    wire    [ADDR_W-1:0]                pl_addr_unpkd[0:NODES-1];
    wire    [DATA_W-1:0]                pl_wr_data_unpkd[0:NODES-1];
    wire    [MEM_W-1:0]                 trans_max_addr_unpkd[0:NODES-1];
    wire    [MEM_W-1:0]                 trans_base_addr_unpkd[0:NODES-1];
    wire    [DATA_W-1:0]                pl_rd_data_unpkd[0:NODES-1];
    wire    [MEM_W*WINDOW_W-1:0]        phy_map_addr_unpkd[0:NODES-1];
    wire    [MEM_CTRL*WINDOW_W-1:0]     mem_op_ctrl_unpkd[0:NODES-1];
    wire    [DATA_W*WINDOW_W-1:0]       mem_wr_data_unpkd[0:NODES-1];
    wire    [DATA_W*WINDOW_W-1:0]       mem_rd_data_unpkd[0:NODES-1];
    wire    [MEM_W-1:0]                 vtp_map_unpkd[0:MEM_PORTS-1];
    
    wire    [WINDOW_W-1:0]              i_phy_map_valid[0:NODES-1];
    wire    [DATA_W-1:0]                mem_rd_data_even[0:EVEN_ODD-1];
    wire    [DATA_W-1:0]                mem_rd_data_odd[0:EVEN_ODD-1];
    wire    [DATA_W-1:0]                mem_wr_data_even[0:EVEN_ODD-1];
    wire    [DATA_W-1:0]                mem_wr_data_odd[0:EVEN_ODD-1];
    wire    [MEM_W-1:0]                 phy_map_addr_even[0:EVEN_ODD-1];
    wire    [MEM_W-1:0]                 phy_map_addr_odd[0:EVEN_ODD-1];
    wire    [EVEN_ODD-1:0]              phy_map_valid_even;
    wire    [EVEN_ODD-1:0]              phy_map_valid_odd;
    wire    [MEM_CTRL-1:0]              mem_op_ctrl_even[0:EVEN_ODD-1];
    wire    [MEM_CTRL-1:0]              mem_op_ctrl_odd[0:EVEN_ODD-1];
    
    // PS related
    wire    [OFFSET-1:0]                ps_offset;
    wire    [MEM_W-1:0]                 ps_port;
    wire    [MEM_W-1:0]                 ps_get_port;
    wire    [MEM_W-1:0]                 ps_phy_port;
    wire                                ps_we;
    wire    [DATA_W-1:0]                ps_rd_data[0:MEM_PORTS-1];
    reg     [DATA_W-1:0]                ps_wr_data[0:MEM_PORTS-1];
    reg     [MEM_CTRL-1:0]              ps_ctrl[0:MEM_PORTS-1];
    
    genvar i;
    integer k;
    
    //generate
    //    for (i = 0; i < NODES; i = i+1) begin
    //        assign trans_base_addr_unpkd[i] = trans_base_addr[i*MEM_W +: MEM_W];
    //        assign trans_max_addr_unpkd[i] = trans_max_addr[i*MEM_W +: MEM_W];
    //        assign pl_addr_unpkd[i] = pl_addr[i*ADDR_W +: ADDR_W];
    //        assign mem_rd_data_unpkd[i] = mem_rd_data[i*DATA_W*WINDOW_W +: DATA_W*WINDOW_W];
    //        assign mem_wr_data[i*DATA_W*WINDOW_W +: DATA_W*WINDOW_W] = mem_wr_data_unpkd[i];
    //        assign pl_rd_data[i*DATA_W +: DATA_W] = pl_rd_data_unpkd[i];
    //        assign pl_wr_data_unpkd[i] = pl_wr_data[i*DATA_W +: DATA_W];
    //        assign phy_map_addr[i*MEM_W*WINDOW_W +: MEM_W*WINDOW_W] = phy_map_addr_unpkd[i];
    //        assign mem_op_ctrl[i*MEM_CTRL*WINDOW_W +: MEM_CTRL*WINDOW_W] = mem_op_ctrl_unpkd[i];
    //    end
    //endgenerate
    
    generate
        for (i = 0; i < EVEN_ODD; i = i+2) begin
            assign mem_rd_data_even[i] = mem_rd_data[(2*i)*DATA_W +: DATA_W];
            assign mem_rd_data_even[i+1] = mem_rd_data[(2*i+1)*DATA_W +: DATA_W];
            assign mem_rd_data_odd[i] = mem_rd_data[(2*i+2)*DATA_W +: DATA_W];
            assign mem_rd_data_odd[i+1] = mem_rd_data[(2*i+3)*DATA_W +: DATA_W];
            assign mem_wr_data[(2*i)*DATA_W +: DATA_W] = mem_wr_data_even[i];
            assign mem_wr_data[(2*i+1)*DATA_W +: DATA_W] = mem_wr_data_even[i+1];
            assign mem_wr_data[(2*i+2)*DATA_W +: DATA_W] = mem_wr_data_odd[i];
            assign mem_wr_data[(2*i+3)*DATA_W +: DATA_W] = mem_wr_data_odd[i+1];
            assign phy_map_addr[(2*i)*MEM_W +: MEM_W] = phy_map_addr_even[i];
            assign phy_map_addr[(2*i+1)*MEM_W +: MEM_W] = phy_map_addr_even[i+1];
            assign phy_map_addr[(2*i+2)*MEM_W +: MEM_W] = phy_map_addr_odd[i];
            assign phy_map_addr[(2*i+3)*MEM_W +: MEM_W] = phy_map_addr_odd[i+1];
            assign phy_map_valid[2*i] = phy_map_valid_even[i];
            assign phy_map_valid[2*i+1] = phy_map_valid_even[i+1];
            assign phy_map_valid[2*i+2] = phy_map_valid_odd[i];
            assign phy_map_valid[2*i+3] = phy_map_valid_odd[i+1];
            assign mem_op_ctrl[(2*i)*MEM_CTRL +: MEM_CTRL] = mem_op_ctrl_even[i];
            assign mem_op_ctrl[(2*i+1)*MEM_CTRL +: MEM_CTRL] = mem_op_ctrl_even[i+1];
            assign mem_op_ctrl[(2*i+2)*MEM_CTRL +: MEM_CTRL] = mem_op_ctrl_odd[i];
            assign mem_op_ctrl[(2*i+3)*MEM_CTRL +: MEM_CTRL] = mem_op_ctrl_odd[i+1];
        end
    endgenerate
    
    generate
        for (i = 0; i < EVEN_ODD; i = i+1) begin
            assign mem_wr_data_even[i] = mem_wr_data_unpkd[i][0 +: DATA_W];
            assign mem_wr_data_odd[i] = mem_wr_data_unpkd[i][DATA_W +: DATA_W];
            assign phy_map_addr_even[i] = phy_map_addr_unpkd[i][0 +: MEM_W];
            assign phy_map_addr_odd[i] = phy_map_addr_unpkd[i][MEM_W +: MEM_W];
            assign phy_map_valid_even[i] = i_phy_map_valid[i][0];
            assign phy_map_valid_odd[i] = i_phy_map_valid[i][1];
            assign mem_op_ctrl_even[i] = mem_op_ctrl_unpkd[i][0 +: MEM_CTRL];
            assign mem_op_ctrl_odd[i] = mem_op_ctrl_unpkd[i][MEM_CTRL +: MEM_CTRL];
        end
    endgenerate
    
    generate
        for (i = 0; i < NODES; i = i+1) begin
            assign trans_base_addr_unpkd[i] = trans_base_addr[i*MEM_W +: MEM_W];
            assign trans_max_addr_unpkd[i] = trans_max_addr[i*MEM_W +: MEM_W];
            assign pl_addr_unpkd[i] = pl_addr[i*ADDR_W +: ADDR_W];
            assign mem_rd_data_unpkd[i][0 +: DATA_W] = mem_rd_data_even[i];
            assign mem_rd_data_unpkd[i][DATA_W +: DATA_W] = mem_rd_data_odd[i];
            assign pl_rd_data[i*DATA_W +: DATA_W] = pl_rd_data_unpkd[i];
            assign pl_wr_data_unpkd[i] = pl_wr_data[i*DATA_W +: DATA_W];
        end
    endgenerate
    
    generate
        for (i = 0; i < MEM_PORTS; i = i+1) begin
            assign vtp_map_unpkd[i] = vtp_map[i*MEM_W +: MEM_W];
            assign ps_rd_data[i] = mem_ps_rd_data[i*DATA_W +: DATA_W];
            assign mem_ps_wr_data[i*DATA_W +: DATA_W] = ps_wr_data[i];
            assign mem_ps_addr[i*MEM_CTRL +: MEM_CTRL] = ps_ctrl[i];
        end
    endgenerate
    
    generate
        for (i = 0; i < NODES; i = i+1) begin
            trans_port #(
                .BUFFER_TRANS(BUFFER_TRANS),
                .MEM_PORTS(MEM_PORTS),
                .DATA_W(DATA_W),
                .OFFSET(OFFSET),
                .MEM_W(MEM_W),
                .ADDR_W(ADDR_W),
                .MEM_CTRL(MEM_CTRL),
                .BENES_PORTS(BENES_PORTS),
                .WINDOW_W(WINDOW_W)
            ) trans_port_i (
                .clk(clk),
                .reset_n(reset_n),
                //.ap_rebase(ap_rebase),
                .benes_restart(benes_restart),
                .benes_batch_start(benes_batch_start),
                //.manual(manual),
                //.window_base(window_base),
                // From proc
                .pl_addr_valid(pl_addr_valid[i]),
                .pl_addr(pl_addr_unpkd[i]),
                .pl_wr_data(pl_wr_data_unpkd[i]),
                // From memory
                .mem_rd_data(mem_rd_data_unpkd[i]),
                // From Allocator (unicast)
                .trans_base_addr(trans_base_addr_unpkd[i]),
                .trans_max_addr(trans_max_addr_unpkd[i]),
                .trans_active(trans_active[i]),
                // Broadcasted to all translators
                .vtp_map(vtp_map),
                
                // To proc
                .trans_port_ready(trans_port_ready[i]),
                .pl_rd_data(pl_rd_data_unpkd[i]),
                // To Benes
                .phy_map_addr(phy_map_addr_unpkd[i]),
                //.phy_map_valid(phy_map_valid[i*WINDOW_W +: WINDOW_W]),
                .phy_map_valid(i_phy_map_valid[i]),
                // To memory
                .mem_pl_ctrl(mem_op_ctrl_unpkd[i]),
                .mem_wr_data(mem_wr_data_unpkd[i])
            );
        end
    endgenerate
    
    // PS to MEM Translator
    assign ps_we     = ps_addr_bus[ADDR_W-1] & ps_addr_valid;
    assign ps_offset = ps_addr_bus[0 +: OFFSET];
    assign ps_port = ps_addr_bus[OFFSET +: MEM_W];
    assign ps_get_port = trans_base_addr_unpkd[ps_trans_id] + ps_port;
    assign ps_phy_port = vtp_map_unpkd[ps_get_port];
    
    assign ps_rd_data_bus = ps_rd_data[ps_phy_port];
    
    always @(*) begin
        for (k = 0; k < MEM_PORTS; k = k+1) begin
            ps_wr_data[k] = 0;
            ps_ctrl[k] = 0;
            if (ps_phy_port == k) begin
                ps_wr_data[k] = ps_wr_data_bus;
                ps_ctrl[k] = {ps_we, ps_offset};
            end
        end
    end
    
endmodule
