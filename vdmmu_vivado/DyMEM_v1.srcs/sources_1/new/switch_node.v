`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:07:52 PM
// Design Name: 
// Module Name: switch_node
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


module switch_node #(
        parameter DATA_W            = 64
    )(
        input wire                  scb_in,
        input wire  [DATA_W-1:0]    in_0,
        input wire  [DATA_W-1:0]    in_1,
        
        output wire [DATA_W-1:0]    out_0,
        output wire [DATA_W-1:0]    out_1
    );
    
    assign out_0 = (scb_in) ? in_1 : in_0;
    assign out_1 = (scb_in) ? in_0 : in_1;
    
endmodule
