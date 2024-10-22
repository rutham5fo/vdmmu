`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 02:55:42 PM
// Design Name: 
// Module Name: switch_stage_B_down
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


module switch_stage_B_down #(
        parameter INPUTS            = 32,
        parameter NODES             = INPUTS/2,
        parameter DATA_W            = 64,
        parameter STAGE_NUM         = 0,
        parameter STAGES            = $clog2(NODES)+1
    )(
        input wire  [NODES-1:0]         scb_in,
        input wire  [DATA_W*INPUTS-1:0] down_in,
        
        output wire [DATA_W*INPUTS-1:0] down_out
    );
    
    localparam SPLIT            = (STAGE_NUM < STAGES-1) ? 2**(STAGE_NUM+1) : 2**STAGE_NUM;
    
    wire    [DATA_W-1:0]        down_in_unpkd[0:INPUTS-1];
    wire    [DATA_W-1:0]        i_down_out[0:INPUTS-1];
    wire    [DATA_W-1:0]        down_out_unpkd[0:INPUTS-1];
    
    genvar i;
    
    // Packed to unpacked
    generate
        for (i = 0; i < INPUTS; i = i+1) begin
            assign down_in_unpkd[i] = down_in[i*DATA_W +: DATA_W];
            assign down_out[i*DATA_W +: DATA_W] = down_out_unpkd[i];
        end
    endgenerate
    
    // Stage output mapping
    generate      
        if (STAGE_NUM < STAGES-1) begin
            for (i = 0; i < INPUTS; i = i+1) begin
                if ((i/SPLIT)%2 == 0) begin
                    if (i%2 == 0) assign down_out_unpkd[i] = i_down_out[i];
                    else assign down_out_unpkd[i] = i_down_out[i+SPLIT-1];
                end
                else begin
                    if (i%2 == 0) assign down_out_unpkd[i] = i_down_out[i-SPLIT+1];
                    else assign down_out_unpkd[i] = i_down_out[i];
                end
            end
        end
        else begin
            for (i = 0; i < INPUTS; i = i+1) begin
                if (i < SPLIT) assign down_out_unpkd[i] = i_down_out[2*i];
                else assign down_out_unpkd[i] = i_down_out[2*(i-SPLIT)+1];
            end
        end
    endgenerate
    
    // Node generation
    generate
        for (i = 0; i < NODES; i = i+1) begin
            switch_node #(
                .DATA_W(DATA_W)
            ) switch_node_i (
                .scb_in(scb_in[i]),
                .in_0(down_in_unpkd[2*i]),
                .in_1(down_in_unpkd[2*i+1]),
                
                .out_0(i_down_out[2*i]),
                .out_1(i_down_out[2*i+1])
            );
        end
    endgenerate
    
endmodule
