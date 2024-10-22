`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:27:40 PM
// Design Name: 
// Module Name: butt_node
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


module butt_node #(
        parameter STAGE_NUM         = 0,
        parameter INPUTS            = 32,
        parameter ADDR_W            = $clog2(INPUTS)-STAGE_NUM,
        parameter DATA_W            = $clog2(INPUTS)
    )(
        input wire  [ADDR_W-1:0]        i_addr_0,
        input wire  [ADDR_W-1:0]        i_addr_1,
        input wire  [DATA_W-1:0]        i_data_0,
        input wire  [DATA_W-1:0]        i_data_1,
        input wire                      i_stat_0,
        input wire                      i_stat_1,
        input wire                      i_valid_0,
        input wire                      i_valid_1,
        
        output wire [ADDR_W-1:0]        o_addr_0,
        output wire [ADDR_W-1:0]        o_addr_1,
        output wire [DATA_W-1:0]        o_data_0,
        output wire [DATA_W-1:0]        o_data_1,
        output wire                     o_stat_0,
        output wire                     o_stat_1,
        output wire                     o_valid_0,
        output wire                     o_valid_1
    );
    
    wire                        scb;
    
    assign scb = (i_valid_0) ? i_addr_0[0] : ~i_addr_1[0];
    
    assign o_addr_0 = (scb) ? i_addr_1 : i_addr_0;
    assign o_addr_1 = (scb) ? i_addr_0 : i_addr_1;
    assign o_data_0 = (scb) ? i_data_1 : i_data_0;
    assign o_data_1 = (scb) ? i_data_0 : i_data_1;
    assign o_stat_0 = (scb) ? i_stat_1 : i_stat_0;
    assign o_stat_1 = (scb) ? i_stat_0 : i_stat_1;
    assign o_valid_0 = (scb) ? i_valid_1 : i_valid_0;
    assign o_valid_1 = (scb) ? i_valid_0 : i_valid_1;
    
endmodule
