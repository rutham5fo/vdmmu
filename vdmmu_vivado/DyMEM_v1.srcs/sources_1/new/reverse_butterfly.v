`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:30:10 PM
// Design Name: 
// Module Name: reverse_butterfly
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


module reverse_butterfly #(
        parameter TEST_EN           = 0,
        parameter INPUTS            = 32,
        parameter NODES             = INPUTS/2,
        parameter ADDR_W            = $clog2(INPUTS),
        parameter DATA_W            = $clog2(INPUTS),
        parameter STAGES            = $clog2(INPUTS)
    )(
        input wire  [ADDR_W*INPUTS-1:0]     addr_in,
        input wire  [DATA_W*INPUTS-1:0]     data_in,
        input wire  [INPUTS-1:0]            status_in,
        input wire  [INPUTS-1:0]            valid_in,
        
        output wire [DATA_W*INPUTS-1:0]     data_out,
        output wire [INPUTS-1:0]            status_out,
        output wire [INPUTS-1:0]            valid_out
    );
    
    wire    [ADDR_W*INPUTS-1:0]         stage_addr_out[0:STAGES-1];
    wire    [DATA_W*INPUTS-1:0]         stage_data_out[0:STAGES-1];
    wire    [INPUTS-1:0]                stage_stat_out[0:STAGES-1];
    wire    [INPUTS-1:0]                stage_valid_out[0:STAGES-1];
    
    assign data_out = stage_data_out[STAGES-1];
    assign status_out = stage_stat_out[STAGES-1];
    assign valid_out = stage_valid_out[STAGES-1];
        
    genvar i;
    
    generate
        for (i = 0; i < STAGES; i = i+1) begin
            localparam STAGE_ADDR_W         = ADDR_W-i;
            if (i == 0) begin
                butt_stage #(
                    .TEST_EN(TEST_EN),
                    .STAGE_NUM(i),
                    .INPUTS(INPUTS),
                    .NODES(NODES),
                    .ADDR_W(STAGE_ADDR_W),
                    .DATA_W(DATA_W),
                    .STAGES(STAGES)
                ) butt_stage_i (
                    .i_addr(addr_in),
                    .i_data(data_in),
                    .i_stat(status_in),
                    .i_valid(valid_in),
                    
                    .o_addr(stage_addr_out[i]),
                    .o_data(stage_data_out[i]),
                    .o_stat(stage_stat_out[i]),
                    .o_valid(stage_valid_out[i])
                );
            end
            else begin
                butt_stage #(
                    .TEST_EN(TEST_EN),
                    .STAGE_NUM(i),
                    .INPUTS(INPUTS),
                    .NODES(NODES),
                    .ADDR_W(ADDR_W),
                    .DATA_W(DATA_W),
                    .STAGES(STAGES)
                ) butt_stage_i (
                    .i_addr(stage_addr_out[i-1]),
                    .i_data(stage_data_out[i-1]),
                    .i_stat(stage_stat_out[i-1]),
                    .i_valid(stage_valid_out[i-1]),
                    
                    .o_addr(stage_addr_out[i]),
                    .o_data(stage_data_out[i]),
                    .o_stat(stage_stat_out[i]),
                    .o_valid(stage_valid_out[i])
                );
            end
        end
    endgenerate
    
endmodule
