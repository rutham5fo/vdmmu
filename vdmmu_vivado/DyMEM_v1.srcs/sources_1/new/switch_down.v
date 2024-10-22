`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:12:18 PM
// Design Name: 
// Module Name: switch_down
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


module switch_down #(
        parameter DATA_W            = 64,
        parameter INPUTS            = 16,
        parameter OUTPUTS           = 32,
        parameter NODES_A           = INPUTS/2,
        parameter NODES_B           = OUTPUTS/2,
        parameter STAGES_A          = $clog2(NODES_A)-1,
        parameter STAGES_B          = $clog2(NODES_B)+1
    )(
        input wire  [NODES_A*STAGES_A-1:0]  scb_A_in,
        input wire  [NODES_B*STAGES_B-1:0]  scb_B_in,
        input wire  [DATA_W*INPUTS-1:0]     data_in,
        
        output wire [DATA_W*OUTPUTS-1:0]    data_out
    );
    
    wire    [DATA_W*OUTPUTS-1:0]        i_data_out;
    
    switch_A_down #(
        .DATA_W(DATA_W),
        .INPUTS(INPUTS),
        .OUTPUTS(OUTPUTS),
        .NODES(NODES_A),
        .STAGES(STAGES_A)
    ) switch_A_down_i (
        .scb_in(scb_A_in),
        .down_in(data_in),
        
        .down_out(i_data_out)
    );
    
    switch_B_down #(
        .DATA_W(DATA_W),
        .INPUTS(OUTPUTS),
        .NODES(NODES_B),
        .STAGES(STAGES_B)
    ) switch_B_down_i (
        .scb_in(scb_B_in),
        .down_in(i_data_out),
        
        .down_out(data_out)
    );
    
endmodule
