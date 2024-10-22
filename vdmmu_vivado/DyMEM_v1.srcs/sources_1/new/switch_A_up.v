`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 03:13:40 PM
// Design Name: 
// Module Name: switch_A_up
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


module switch_A_up #(
        parameter DATA_W            = 64,
        parameter INPUTS            = 16,
        parameter NODES             = INPUTS/2,
        parameter STAGES            = $clog2(NODES)-1
    )(
        input wire  [NODES*STAGES-1:0]      scb_in,
        input wire  [DATA_W*INPUTS-1:0]     up_in,
        
        output wire [DATA_W*INPUTS-1:0]     up_out
    );
    
    wire    [NODES-1:0]             stage_scb[0:STAGES-1];
    wire    [DATA_W*INPUTS-1:0]     stage_up_out[0:STAGES-1];
    
    genvar i;
    
    assign up_out = stage_up_out[0];
    
    generate
        for (i = 0; i < STAGES; i = i+1) begin
            assign stage_scb[i] = scb_in[i*NODES +: NODES];
        end
    endgenerate
        
    generate
        for (i = 0; i < STAGES; i = i+1) begin
            if (i == STAGES-1) begin
                switch_stage_A_up #(
                    .DATA_W(DATA_W),
                    .INPUTS(INPUTS),
                    .NODES(NODES),
                    .STAGES(STAGES),
                    .STAGE_NUM(i)
                ) stage_A_up_i (
                    .scb_in(stage_scb[i]),
                    .up_in(up_in),
                    
                    .up_out(stage_up_out[i])
                );
            end
            else begin
                switch_stage_A_up #(
                    .DATA_W(DATA_W),
                    .INPUTS(INPUTS),
                    .NODES(NODES),
                    .STAGES(STAGES),
                    .STAGE_NUM(i)
                ) stage_A_up_i (
                    .scb_in(stage_scb[i]),
                    .up_in(stage_up_out[i+1]),
                    
                    .up_out(stage_up_out[i])
                );
            end
        end
    endgenerate
    
endmodule
