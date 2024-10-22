`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 03:12:19 PM
// Design Name: 
// Module Name: switch_stage_A_up
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


module switch_stage_A_up #(
        parameter DATA_W            = 64,
        parameter INPUTS            = 16,
        parameter NODES             = INPUTS/2,
        parameter STAGES            = $clog2(NODES),
        parameter STAGE_NUM         = 0
    )(
        input wire  [NODES-1:0]         scb_in,
        input wire  [DATA_W*INPUTS-1:0] up_in,
        
        output wire [DATA_W*INPUTS-1:0] up_out
    );
    
    localparam SPLIT          = 2**(STAGES-STAGE_NUM+1);
    
    wire    [DATA_W-1:0]        up_in_unpkd[0:INPUTS-1];
    wire    [DATA_W-1:0]        up_out_unpkd[0:INPUTS-1];
    
    wire    [DATA_W-1:0]        i_up_in[0:INPUTS-1];
    
    genvar i;
    
    generate
        for (i = 0; i < INPUTS; i = i+1) begin
            assign up_in_unpkd[i] = up_in[i*DATA_W +: DATA_W];
            assign up_out[i*DATA_W +: DATA_W] = up_out_unpkd[i];
        end
    endgenerate
    
    // Stage output mapping
    generate
        for (i = 0; i < INPUTS; i = i+1) begin
            if ((i/SPLIT)%2 == 0) begin
                //if (i%2 == 0) assign i_up_in[i] = up_in_unpkd[i];
                //else assign i_up_in[i] = up_in_unpkd[i+SPLIT-1];
                if (i%2 == 0) assign i_up_in[i] = up_in_unpkd[i];
                else assign i_up_in[i+SPLIT-1] = up_in_unpkd[i];
            end
            else begin
                //if (i%2 == 0) assign i_up_in[i] = up_in_unpkd[i-SPLIT+1];
                //else assign i_up_in[i] = up_in_unpkd[i];
                if (i%2 == 0) assign i_up_in[i-SPLIT+1] = up_in_unpkd[i];
                else assign i_up_in[i] = up_in_unpkd[i];
            end
        end
    endgenerate
    
    generate
        for (i = 0; i < NODES; i = i+1) begin
            switch_node #(
                .DATA_W(DATA_W)
            ) switch_node_i (
                .scb_in(scb_in[i]),
                .in_0(i_up_in[2*i]),
                .in_1(i_up_in[2*i+1]),
                
                .out_0(up_out_unpkd[2*i]),
                .out_1(up_out_unpkd[2*i+1])
            );
        end
    endgenerate
    
endmodule
