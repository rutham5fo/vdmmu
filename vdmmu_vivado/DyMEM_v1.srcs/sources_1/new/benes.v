`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:06:32 PM
// Design Name: 
// Module Name: benes
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


module benes #(
        parameter TEST_EN           = 0,
        parameter MEM_PORTS         = 32,
        parameter TRANSLATORS       = 16,
        parameter NODES_A           = TRANSLATORS/2,
        parameter NODES_B           = MEM_PORTS/2,
        parameter ADDR_W            = $clog2(MEM_PORTS),
        parameter STAGES_A          = $clog2(NODES_A)-1,
        parameter STAGES_B          = $clog2(NODES_B)+1
    )(
        input wire                              clk,
        input wire                              reset_n,
        input wire  [ADDR_W*TRANSLATORS-1:0]    addr_in,
        input wire  [TRANSLATORS-1:0]           addr_valid_in,
        input wire                              stage_restart,
        
        output wire [MEM_PORTS-1:0]             port_valid_out,
        output wire [NODES_A*STAGES_A-1:0]      stage_A_scb_out,
        output wire [NODES_B*STAGES_B-1:0]      stage_B_scb_out,
        output wire                             batch_start
    );
    
    //wire    [ADDR_W*TRANSLATORS-1:0]            i_A_addr_out;
    //wire    [TRANSLATORS-1:0]                   i_A_valid_out;
    wire    [ADDR_W*MEM_PORTS-1:0]              i_A_addr_out;
    wire    [MEM_PORTS-1:0]                     i_A_valid_out;
    wire    [NODES_A*STAGES_A-1:0]              i_A_scb_out;
    wire                                        i_A_done;
    
    // [NOTE]: For each stage added, manually edit accumulators inside stage_A_top
    
    assign batch_start = i_A_done;
    
    benes_stage_A_top #(
        .TEST_EN(TEST_EN),
        .INPUTS(TRANSLATORS),
        .OUTPUTS(MEM_PORTS),
        .NODES(NODES_A),
        .ADDR_W(ADDR_W),
        .STAGES(STAGES_A)
    ) benes_stage_A_top_i (
        .clk(clk),
        .reset_n(reset_n),
        .addr_in(addr_in),
        .addr_valid_in(addr_valid_in),
        .stage_restart(stage_restart),
        
        .addr_out(i_A_addr_out),
        .addr_valid_out(i_A_valid_out),
        .scb_out(i_A_scb_out),
        .stage_done(i_A_done)
    );
    
    benes_stage_B_top #(
        .TEST_EN(TEST_EN),
        .INPUTS(MEM_PORTS),
        .NODES(NODES_B),
        .ADDR_W(ADDR_W),
        .STAGES(STAGES_B),
        .STAGES_A(STAGES_A)
    ) benes_stage_B_top_i (
        .clk(clk),
        .reset_n(reset_n),
        .addr_in(i_A_addr_out),
        .valid_in(i_A_valid_out),
        .stage_A_scb_in(i_A_scb_out),
        .stage_A_done(i_A_done),
        
        // --------- Test Output ----------------
        //output wire [ADDR_W*INPUTS-1:0]     addr_out,
        // --------------------------------------
        .valid_out(port_valid_out),
        .stage_A_scb_out(stage_A_scb_out),
        .stage_B_scb_out(stage_B_scb_out)
    );
    
endmodule
