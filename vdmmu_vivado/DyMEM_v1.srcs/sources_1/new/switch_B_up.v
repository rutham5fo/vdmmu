`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 03:08:10 PM
// Design Name: 
// Module Name: switch_B_up
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


module switch_B_up #(
        parameter DATA_W            = 64,
        parameter INPUTS            = 32,
        parameter OUTPUTS           = 16,
        parameter NODES             = INPUTS/2,
        parameter STAGES            = $clog2(NODES)+1
    )(
        input wire  [NODES*STAGES-1:0]      scb_in,
        input wire  [DATA_W*INPUTS-1:0]     up_in,
        
        output wire [DATA_W*OUTPUTS-1:0]    up_out
    );
    
    localparam IO_FACTOR                = INPUTS/OUTPUTS;
    localparam IO_DIST                  = 2*IO_FACTOR;
    localparam EVEN_ODD                 = OUTPUTS/2;
    
    wire    [NODES-1:0]             stage_scb[0:STAGES-1];
    wire    [DATA_W*INPUTS-1:0]     stage_up_out[0:STAGES-1];
    //wire    [DATA_W*INPUTS-1:0]     i_data_out;
    
    wire    [DATA_W-1:0]            o_data_out[0:OUTPUTS-1];
    wire    [DATA_W-1:0]            i_data_out_unpkd[0:INPUTS-1];
    wire    [DATA_W-1:0]            i_data_out_even[0:EVEN_ODD-1];
    wire    [DATA_W-1:0]            i_data_out_odd[0:EVEN_ODD-1];
    
    genvar i;
    
    //assign i_data_out = stage_up_out[0];
        
    generate
        for (i = 0; i < STAGES; i = i+1) begin
            assign stage_scb[i] = scb_in[i*NODES +: NODES];
        end
    endgenerate
    
    //generate
    //    for (i = 0; i < OUTPUTS; i = i+1) begin
    //        //assign up_out[i*DATA_W +: DATA_W] = i_data_out[(2*i)*DATA_W +: DATA_W];
    //        assign up_out[i*DATA_W +: DATA_W] = i_data_out[(IO_DIST*i)*DATA_W +: DATA_W];
    //    end
    //endgenerate
    
    generate
        for (i = 0; i < OUTPUTS; i = i+1) begin
            assign up_out[i*DATA_W +: DATA_W] = o_data_out[i];
        end
    endgenerate
    
    generate
        for (i = 0; i < INPUTS; i = i+1) begin
            assign i_data_out_unpkd[i] = stage_up_out[0][i*DATA_W +: DATA_W];
        end
    endgenerate
    
    generate
        for (i = 0; i < EVEN_ODD; i = i+1) begin
            assign i_data_out_even[i] = i_data_out_unpkd[i*IO_DIST];
            assign i_data_out_odd[i] = i_data_out_unpkd[i*IO_DIST+1];
        end
    endgenerate
    
    generate
        for (i = 0; i < EVEN_ODD; i = i+2) begin
            assign o_data_out[2*i] = i_data_out_even[i];
            assign o_data_out[2*i+1] = i_data_out_even[i+1];
            assign o_data_out[2*i+2] = i_data_out_odd[i];
            assign o_data_out[2*i+3] = i_data_out_odd[i+1];
        end
    endgenerate
        
    generate
        for (i = 0; i < STAGES; i = i+1) begin
            if (i == STAGES-1) begin
                switch_stage_B_up #(
                    .DATA_W(DATA_W),
                    .INPUTS(INPUTS),
                    .NODES(NODES),
                    .STAGES(STAGES),
                    .STAGE_NUM(i)
                ) stage_B_up_i (
                    .scb_in(stage_scb[i]),
                    .up_in(up_in),
                    
                    .up_out(stage_up_out[i])
                );
            end
            else begin
                switch_stage_B_up #(
                    .DATA_W(DATA_W),
                    .INPUTS(INPUTS),
                    .NODES(NODES),
                    .STAGES(STAGES),
                    .STAGE_NUM(i)
                ) stage_B_up_i (
                    .scb_in(stage_scb[i]),
                    .up_in(stage_up_out[i+1]),
                    
                    .up_out(stage_up_out[i])
                );
            end
        end
    endgenerate
    
endmodule
