`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 03:00:39 PM
// Design Name: 
// Module Name: switch_B_down
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


module switch_B_down #(
        parameter DATA_W            = 64,
        parameter INPUTS            = 32,
        parameter NODES             = INPUTS/2,
        parameter STAGES            = $clog2(NODES)+1
    )(
        input wire  [NODES*STAGES-1:0]      scb_in,
        input wire  [DATA_W*INPUTS-1:0]     down_in,
        
        output wire [DATA_W*INPUTS-1:0]     down_out
    );
    
    wire    [NODES-1:0]             stage_scb[0:STAGES-1];
    wire    [DATA_W*INPUTS-1:0]     stage_down_out[0:STAGES-1];
    
    genvar i;
    
    assign down_out = stage_down_out[STAGES-1];
    
    generate
        for (i = 0; i < STAGES; i = i+1) begin
            assign stage_scb[i] = scb_in[i*NODES +: NODES];
        end
    endgenerate
        
    generate
        for (i = 0; i < STAGES; i = i+1) begin
            if (i == 0) begin
                switch_stage_B_down #(
                    .DATA_W(DATA_W),
                    .INPUTS(INPUTS),
                    .NODES(NODES),
                    .STAGES(STAGES),
                    .STAGE_NUM(i)
                ) stage_B_down_i (
                    .scb_in(stage_scb[i]),
                    .down_in(down_in),
                    
                    .down_out(stage_down_out[i])
                );
            end
            else begin
                switch_stage_B_down #(
                    .DATA_W(DATA_W),
                    .INPUTS(INPUTS),
                    .NODES(NODES),
                    .STAGES(STAGES),
                    .STAGE_NUM(i)
                ) stage_B_down_i (
                    .scb_in(stage_scb[i]),
                    .down_in(stage_down_out[i-1]),
                    
                    .down_out(stage_down_out[i])
                );
            end
        end
    endgenerate
    
endmodule
