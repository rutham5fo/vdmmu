`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 02:58:30 PM
// Design Name: 
// Module Name: switch_A_down
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


module switch_A_down #(
        parameter DATA_W            = 64,
        parameter INPUTS            = 16,
        parameter OUTPUTS           = 32,
        parameter NODES             = INPUTS/2,
        parameter STAGES            = $clog2(NODES)-1
    )(
        input wire  [NODES*STAGES-1:0]      scb_in,
        input wire  [DATA_W*INPUTS-1:0]     down_in,
        
        output wire [DATA_W*OUTPUTS-1:0]    down_out
    );
    
    localparam IO_FACTOR            = OUTPUTS/INPUTS;
    localparam IO_DIST              = 2*IO_FACTOR;
    localparam EVEN_ODD             = INPUTS/2;
    
    wire    [NODES-1:0]             stage_scb[0:STAGES-1];
    wire    [DATA_W*INPUTS-1:0]     stage_down_out[0:STAGES-1];
    //wire    [DATA_W*INPUTS-1:0]     i_data_out;
    wire    [DATA_W-1:0]            i_data_out_unpkd[0:INPUTS-1];
    wire    [DATA_W-1:0]            i_data_out_even[0:EVEN_ODD-1];
    wire    [DATA_W-1:0]            i_data_out_odd[0:EVEN_ODD-1];
    wire    [DATA_W-1:0]            data_out_unpkd[0:OUTPUTS-1];
    
    genvar i, j;
    
    //assign i_data_out = stage_down_out[STAGES-1];
    
    generate
        for (i = 0; i < STAGES; i = i+1) begin
            assign stage_scb[i] = scb_in[i*NODES +: NODES];
        end
    endgenerate
    
    //generate
    //    for (i = 0; i < INPUTS; i = i+1) begin
    //        for (j = 0; j < IO_DIST; j = j+1) begin
    //            assign down_out[(IO_DIST*i+j)*DATA_W +: DATA_W] = (j == 0) ? i_data_out[i*DATA_W +: DATA_W] : 0;
    //        end
    //        //assign down_out[(2*i)*DATA_W +: DATA_W] = i_data_out[i*DATA_W +: DATA_W];
    //        //assign down_out[(2*i+1)*DATA_W +: DATA_W] = 0;
    //    end
    //endgenerate
    
    generate
        for (i = 0; i < OUTPUTS; i = i+1) begin
            assign down_out[i*DATA_W +: DATA_W] = data_out_unpkd[i];
        end
    endgenerate
    
    generate
        for (i = 0; i < INPUTS; i = i+1) begin
            assign i_data_out_unpkd[i] = stage_down_out[STAGES-1][i*DATA_W +: DATA_W];
        end
    endgenerate
    
    generate
        for (i = 0; i < EVEN_ODD; i = i+2) begin
            assign i_data_out_even[i] = i_data_out_unpkd[2*i];
            assign i_data_out_even[i+1] = i_data_out_unpkd[2*i+1];
            assign i_data_out_odd[i] = i_data_out_unpkd[2*i+2];
            assign i_data_out_odd[i+1] = i_data_out_unpkd[2*i+3];
        end
    endgenerate
    
    generate
        for (i = 0; i < EVEN_ODD; i = i+1) begin
            for (j = 0; j < IO_DIST; j = j+1) begin
                if (j < 2) begin
                    if (j%2 == 0) begin
                        assign data_out_unpkd[IO_DIST*i+j] = i_data_out_even[i];
                    end
                    else begin
                        assign data_out_unpkd[IO_DIST*i+j] = i_data_out_odd[i];
                    end
                end
                else begin
                    assign data_out_unpkd[IO_DIST*i+j] = 0;
                end
            end
        end
    endgenerate
    
    generate
        for (i = 0; i < STAGES; i = i+1) begin
            if (i == 0) begin
                switch_stage_A_down #(
                    .DATA_W(DATA_W),
                    .INPUTS(INPUTS),
                    .NODES(NODES),
                    .STAGES(STAGES),
                    .STAGE_NUM(i)
                ) stage_A_down_i (
                    .scb_in(stage_scb[i]),
                    .down_in(down_in),
                    
                    .down_out(stage_down_out[i])
                );
            end
            else begin
                switch_stage_A_down #(
                    .DATA_W(DATA_W),
                    .INPUTS(INPUTS),
                    .NODES(NODES),
                    .STAGES(STAGES),
                    .STAGE_NUM(i)
                ) stage_A_down_i (
                    .scb_in(stage_scb[i]),
                    .down_in(stage_down_out[i-1]),
                    
                    .down_out(stage_down_out[i])
                );
            end
        end
    endgenerate
    
endmodule
