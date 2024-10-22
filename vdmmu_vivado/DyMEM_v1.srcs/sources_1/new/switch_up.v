`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:15:08 PM
// Design Name: 
// Module Name: switch_up
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


module switch_up #(
        parameter DATA_W            = 64,
        parameter INPUTS            = 32,
        parameter OUTPUTS           = 16,
        parameter NODES_A           = OUTPUTS/2,
        parameter NODES_B           = INPUTS/2,
        parameter STAGES_A          = $clog2(NODES_A)-1,
        parameter STAGES_B          = $clog2(NODES_B)+1
    )(
        input wire  [NODES_A*STAGES_A-1:0]  scb_A_in,
        input wire  [NODES_B*STAGES_B-1:0]  scb_B_in,
        input wire  [DATA_W*INPUTS-1:0]     data_in,
        
        output wire [DATA_W*OUTPUTS-1:0]    data_out
    );
    
    wire    [DATA_W*OUTPUTS-1:0]        i_data_out;
    
    switch_A_up #(
        .DATA_W(DATA_W),
        .INPUTS(OUTPUTS),
        .NODES(NODES_A),
        .STAGES(STAGES_A)
    ) switch_A_up_i (
        .scb_in(scb_A_in),
        .up_in(i_data_out),
        
        .up_out(data_out)
    );
    
    switch_B_up #(
        .DATA_W(DATA_W),
        .INPUTS(INPUTS),
        .OUTPUTS(OUTPUTS),
        .NODES(NODES_B),
        .STAGES(STAGES_B)
    ) switch_B_up_i (
        .scb_in(scb_B_in),
        .up_in(data_in),
        
        .up_out(i_data_out)
    );
    
endmodule
