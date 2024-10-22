`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2024 03:20:28 AM
// Design Name: 
// Module Name: dmem_stream_combine
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


module dmem_stream_combine #(
        parameter MEM_PORTS     = 16,
        parameter BENES_PORTS   = 8,
        parameter AP_WINDOW     = 2,
        parameter TRANSLATORS   = BENES_PORTS/AP_WINDOW,
        parameter DATA_W        = 8,
        parameter OFFSET        = 11,
        parameter MEM_W         = $clog2(MEM_PORTS),
        parameter BUS_W         = 32,                       // Output bitwidth of stream adapter
        parameter ADDR_W        = OFFSET+MEM_W+1            // +1 for rd,wr en
    )(
        input wire  [BUS_W-1:0]                 i_pl_rd_addr_0,
        input wire  [BUS_W-1:0]                 i_pl_rd_addr_1,
        input wire  [BUS_W-1:0]                 i_pl_rd_addr_2,
        input wire  [BUS_W-1:0]                 i_pl_rd_addr_3,
        
        input wire                              i_pl_rd_addr_vld_0,
        input wire                              i_pl_rd_addr_vld_1,
        input wire                              i_pl_rd_addr_vld_2,
        input wire                              i_pl_rd_addr_vld_3,
        
        input wire  [DATA_W*TRANSLATORS-1:0]    i_mem_rd_data,
        input wire  [TRANSLATORS-1:0]           i_mem_rd_data_vld,
        input wire  [TRANSLATORS-1:0]           i_port_rdy,
        
        output wire [ADDR_W*TRANSLATORS-1:0]    o_pl_rd_addr,
        output wire [TRANSLATORS-1:0]           o_pl_rd_addr_vld,
        
        output wire                             o_port_rdy_0,
        output wire                             o_port_rdy_1,
        output wire                             o_port_rdy_2,
        output wire                             o_port_rdy_3,
        
        output wire                             o_mem_rd_data_vld_0,
        output wire                             o_mem_rd_data_vld_1,
        output wire                             o_mem_rd_data_vld_2,
        output wire                             o_mem_rd_data_vld_3,
        
        output wire [DATA_W-1:0]                o_mem_rd_data_0,
        output wire [DATA_W-1:0]                o_mem_rd_data_1,
        output wire [DATA_W-1:0]                o_mem_rd_data_2,
        output wire [DATA_W-1:0]                o_mem_rd_data_3
    );
    
    wire    [BUS_W-1:0]                 pl_rd_addr_unpkd[0:TRANSLATORS-1];
    wire    [DATA_W-1:0]                mem_rd_data_unpkd[0:TRANSLATORS-1];
    wire    [TRANSLATORS-1:0]           r_pl_we;
    wire    [ADDR_W-2:0]                r_pl_rd_addr[0:TRANSLATORS-1];
    
    genvar i;
    
    assign pl_rd_addr_unpkd[0] = i_pl_rd_addr_0;
    assign pl_rd_addr_unpkd[1] = i_pl_rd_addr_1;
    assign pl_rd_addr_unpkd[2] = i_pl_rd_addr_2;
    assign pl_rd_addr_unpkd[3] = i_pl_rd_addr_3;
    
    assign o_pl_rd_addr_vld[0] = i_pl_rd_addr_vld_0;
    assign o_pl_rd_addr_vld[1] = i_pl_rd_addr_vld_1;
    assign o_pl_rd_addr_vld[2] = i_pl_rd_addr_vld_2;
    assign o_pl_rd_addr_vld[3] = i_pl_rd_addr_vld_3;
    
    assign o_port_rdy_0 = i_port_rdy[0];
    assign o_port_rdy_1 = i_port_rdy[1];
    assign o_port_rdy_2 = i_port_rdy[2];
    assign o_port_rdy_3 = i_port_rdy[3];
    
    assign o_mem_rd_data_vld_0 = i_mem_rd_data_vld[0];
    assign o_mem_rd_data_vld_1 = i_mem_rd_data_vld[1];
    assign o_mem_rd_data_vld_2 = i_mem_rd_data_vld[2];
    assign o_mem_rd_data_vld_3 = i_mem_rd_data_vld[3];
    
    assign o_mem_rd_data_0 = mem_rd_data_unpkd[0];
    assign o_mem_rd_data_1 = mem_rd_data_unpkd[1];
    assign o_mem_rd_data_2 = mem_rd_data_unpkd[2];
    assign o_mem_rd_data_3 = mem_rd_data_unpkd[3];
    
    generate
        for (i = 0; i < TRANSLATORS; i = i+1) begin
            assign r_pl_we[i] = pl_rd_addr_unpkd[i][BUS_W-1];
            assign r_pl_rd_addr[i] = pl_rd_addr_unpkd[i][0 +: ADDR_W-1];
            assign o_pl_rd_addr[i*ADDR_W +: ADDR_W] = {r_pl_we[i], r_pl_rd_addr[i]};
            assign mem_rd_data_unpkd[i] = i_mem_rd_data[i*DATA_W +: DATA_W];
        end
    endgenerate
    
endmodule
