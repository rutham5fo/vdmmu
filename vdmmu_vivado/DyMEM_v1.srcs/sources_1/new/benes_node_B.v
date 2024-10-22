`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:03:28 PM
// Design Name: 
// Module Name: benes_node_B
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


module benes_node_B #(
        parameter INPUTS            = 32,
        parameter NODES             = INPUTS/2,
        parameter ADDR_W            = $clog2(INPUTS),
        parameter STAGE_NUM         = 0
    )(
        input wire                      clk,
        input wire                      reset_n,
        input wire                      scb_en,
        input wire  [ADDR_W-1:0]        in_addr_0,
        input wire  [ADDR_W-1:0]        in_addr_1,
        input wire                      in_valid_0,
        input wire                      in_valid_1,
        
        output wire [ADDR_W-1:0]        out_addr_0,
        output wire [ADDR_W-1:0]        out_addr_1,
        output wire                     out_valid_0,
        output wire                     out_valid_1,
        output wire                     out_scb
    );
    
    reg                     scb;
    
    wire                    scb_drv;
    
    assign out_scb = scb;
    
    assign scb_drv = (in_valid_0) ? in_addr_0[STAGE_NUM] : ~in_addr_1[STAGE_NUM];
    
    assign out_addr_0 = (scb_drv) ? in_addr_1 : in_addr_0;
    assign out_addr_1 = (scb_drv) ? in_addr_0 : in_addr_1;
    assign out_valid_0 = (scb_drv) ? in_valid_1 : in_valid_0;
    assign out_valid_1 = (scb_drv) ? in_valid_0 : in_valid_1;
    
    always @(posedge clk) begin
        if (!reset_n) scb <= 0;
        else scb <= (scb_en) ? scb_drv : scb;
    end
    
endmodule
