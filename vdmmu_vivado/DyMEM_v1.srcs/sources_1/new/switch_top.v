`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:16:42 PM
// Design Name: 
// Module Name: switch_top
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


module switch_top #(
        parameter MEM_PORTS             = 32,
        parameter TRANSLATORS           = 16,
        parameter DATA_D                = 64,
        parameter DATA_U                = 32,
        parameter NODES_A               = TRANSLATORS/2,
        parameter NODES_B               = MEM_PORTS/2,
        parameter STAGES_A              = $clog2(NODES_A)-1,
        parameter STAGES_B              = $clog2(NODES_B)+1
    )(
        input wire  [NODES_A*STAGES_A-1:0]      scb_A_in,
        input wire  [NODES_B*STAGES_B-1:0]      scb_B_in,
        input wire  [DATA_D*TRANSLATORS-1:0]    data_down_in,
        input wire  [DATA_U*MEM_PORTS-1:0]      data_up_in,
        
        output wire [DATA_D*MEM_PORTS-1:0]      data_down_out,
        output wire [DATA_U*TRANSLATORS-1:0]    data_up_out
    );
    
    switch_down #(
        .DATA_W(DATA_D),
        .INPUTS(TRANSLATORS),
        .OUTPUTS(MEM_PORTS),
        .NODES_A(NODES_A),
        .NODES_B(NODES_B),
        .STAGES_A(STAGES_A),
        .STAGES_B(STAGES_B)
    ) switch_down_i (
        .scb_A_in(scb_A_in),
        .scb_B_in(scb_B_in),
        .data_in(data_down_in),
        
        .data_out(data_down_out)
    );
    
    switch_up #(
        .DATA_W(DATA_U),
        .INPUTS(MEM_PORTS),
        .OUTPUTS(TRANSLATORS),
        .NODES_A(NODES_A),
        .NODES_B(NODES_B),
        .STAGES_A(STAGES_A),
        .STAGES_B(STAGES_B)
    ) switch_up_i (
        .scb_A_in(scb_A_in),
        .scb_B_in(scb_B_in),
        .data_in(data_up_in),
        
        .data_out(data_up_out)
    );
    
endmodule
