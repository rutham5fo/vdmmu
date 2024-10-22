`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2024 03:56:00 PM
// Design Name: 
// Module Name: skids
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


module skids #(
        parameter DATA_W            = 32
    )(
        input wire                  clk,
        input wire                  reset_n,
        input wire                  skid_en,
        input wire  [DATA_W-1:0]    din,
        
        output wire [DATA_W-1:0]    dout
    );
    
    wire    [DATA_W-1:0]        i_din;
    
    reg     [DATA_W-1:0]        sreg;
    
    assign i_din = (skid_en) ? din : sreg;
    assign dout = (skid_en) ? din : sreg;
    
    always @(posedge clk) begin
        sreg <= (reset_n) ? i_din : 0;
    end
    
endmodule
