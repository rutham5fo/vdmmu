`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:29:15 PM
// Design Name: 
// Module Name: butt_stage
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


module butt_stage #(
        parameter TEST_EN           = 0,
        parameter STAGE_NUM         = 0,
        parameter INPUTS            = 32,
        parameter NODES             = INPUTS/2,
        parameter ADDR_W            = $clog2(INPUTS),
        parameter DATA_W            = $clog2(INPUTS),
        parameter STAGES            = $clog2(INPUTS)
    )(
        input wire  [ADDR_W*INPUTS-1:0] i_addr,
        input wire  [DATA_W*INPUTS-1:0] i_data,
        input wire  [INPUTS-1:0]        i_stat,
        input wire  [INPUTS-1:0]        i_valid,
        
        output wire [ADDR_W*INPUTS-1:0] o_addr,
        output wire [DATA_W*INPUTS-1:0] o_data,
        output wire [INPUTS-1:0]        o_stat,
        output wire [INPUTS-1:0]        o_valid
    );
    
    localparam STAGE_ADDR_W     = ADDR_W-STAGE_NUM;
    localparam SPLIT            = (STAGE_NUM < STAGES-1) ? 2**(STAGE_NUM+1) : 2**STAGE_NUM;
    
    wire    [STAGE_ADDR_W-1:0]  s_addr_in[0:INPUTS-1];
    wire    [STAGE_ADDR_W-1:0]  s_addr_out[0:INPUTS-1];
    
    wire    [DATA_W-1:0]        data_in_unpkd[0:INPUTS-1];
    wire    [ADDR_W-1:0]        addr_in_unpkd[0:INPUTS-1];
    wire    [STAGE_ADDR_W-1:0]  r_addr_out[0:INPUTS-1];
    wire    [DATA_W-1:0]        r_data_out[0:INPUTS-1];
    wire    [ADDR_W-1:0]        addr_out_unpkd[0:INPUTS-1];
    wire    [DATA_W-1:0]        data_out_unpkd[0:INPUTS-1];
    wire    [INPUTS-1:0]        r_stat_out;
    wire    [INPUTS-1:0]        r_valid_out;
    
    genvar i;
    
    // Test wires
    generate
        if (TEST_EN >= 2) begin                  : BUTTERFLY_STAGE_TEST_EN
            integer k;
            always @(*) begin
                $write("%t: STAGE[%0d] ||| addr_in = {|", $time, STAGE_NUM);
                for (k = 0; k < INPUTS; k = k+1) begin
                    $write(" [%0d](%0d, %0d) |", k, addr_in_unpkd[k], i_valid[k]);
                end
                $display("}");
                $write("%t: STAGE[%0d] ||| i_addr_out = {|", $time, STAGE_NUM);
                for (k = 0; k < INPUTS; k = k+1) begin
                    $write(" [%0d](%0d, %0d) |", k, r_addr_out[k], r_valid_out[k]);
                end
                $display("}");
                $write("%t: STAGE[%0d] ||| addr_out = {|", $time, STAGE_NUM);
                for (k = 0; k < INPUTS; k = k+1) begin
                    $write(" [%0d](%0d, %0d) |", k, addr_out_unpkd[k], o_valid[k]);
                end
                $display("}");
            end
        end
    endgenerate
    //--------------------------------------------
    
    // Packed to unpacked
    generate
        for (i = 0; i < INPUTS; i = i+1) begin
            assign addr_in_unpkd[i] = i_addr[i*ADDR_W +: ADDR_W];
            assign s_addr_in[i] = addr_in_unpkd[i][0 +: STAGE_ADDR_W];
            assign data_in_unpkd[i] = i_data[i*DATA_W +: DATA_W];
            assign addr_out_unpkd[i] = (STAGE_ADDR_W > 1) ? s_addr_out[i][1 +: STAGE_ADDR_W-1] : 0;
            assign o_addr[i*ADDR_W +: ADDR_W] = addr_out_unpkd[i];
            assign o_data[i*DATA_W +: DATA_W] = data_out_unpkd[i];
        end
    endgenerate
    
    // Stage output mapping
    generate      
        if (STAGE_NUM < STAGES-1) begin
            for (i = 0; i < INPUTS; i = i+1) begin
                if ((i/SPLIT)%2 == 0) begin
                    if (i%2 == 0) begin
                        assign s_addr_out[i] = r_addr_out[i];
                        assign data_out_unpkd[i] = r_data_out[i];
                        assign o_stat[i] = r_stat_out[i];
                        assign o_valid[i] = r_valid_out[i];
                    end
                    else begin
                        assign s_addr_out[i] = r_addr_out[i+SPLIT-1];
                        assign data_out_unpkd[i] = r_data_out[i+SPLIT-1];
                        assign o_stat[i] = r_stat_out[i+SPLIT-1];
                        assign o_valid[i] = r_valid_out[i+SPLIT-1];
                    end
                end
                else begin
                    if (i%2 == 0) begin
                        assign s_addr_out[i] = r_addr_out[i-SPLIT+1];
                        assign data_out_unpkd[i] = r_data_out[i-SPLIT+1];
                        assign o_stat[i] = r_stat_out[i-SPLIT+1];
                        assign o_valid[i] = r_valid_out[i-SPLIT+1];
                    end
                    else begin
                        assign s_addr_out[i] = r_addr_out[i];
                        assign data_out_unpkd[i] = r_data_out[i];
                        assign o_stat[i] = r_stat_out[i];
                        assign o_valid[i] = r_valid_out[i];
                    end
                end
            end
        end
        else begin
            for (i = 0; i < INPUTS; i = i+1) begin
                if (i < SPLIT) begin
                    assign s_addr_out[i] = r_addr_out[2*i];
                    assign data_out_unpkd[i] = r_data_out[2*i];
                    assign o_stat[i] = r_stat_out[2*i];
                    assign o_valid[i] = r_valid_out[2*i];
                end
                else begin
                    assign s_addr_out[i] = r_addr_out[2*(i-SPLIT)+1];
                    assign data_out_unpkd[i] = r_data_out[2*(i-SPLIT)+1];
                    assign o_stat[i] = r_stat_out[2*(i-SPLIT)+1];
                    assign o_valid[i] = r_valid_out[2*(i-SPLIT)+1];
                end
            end
        end
    endgenerate
    
    // Node generation
    generate
        for (i = 0; i < NODES; i = i+1) begin
            butt_node #(
                .STAGE_NUM(STAGE_NUM),
                .INPUTS(INPUTS),
                .ADDR_W(STAGE_ADDR_W),
                .DATA_W(DATA_W)
            ) butt_node_i (
                .i_addr_0(s_addr_in[2*i]),
                .i_addr_1(s_addr_in[2*i+1]),
                .i_data_0(data_in_unpkd[2*i]),
                .i_data_1(data_in_unpkd[2*i+1]),
                .i_stat_0(i_stat[2*i]),
                .i_stat_1(i_stat[2*i+1]),
                .i_valid_0(i_valid[2*i]),
                .i_valid_1(i_valid[2*i+1]),
                
                .o_addr_0(r_addr_out[2*i]),
                .o_addr_1(r_addr_out[2*i+1]),
                .o_data_0(r_data_out[2*i]),
                .o_data_1(r_data_out[2*i+1]),
                .o_stat_0(r_stat_out[2*i]),
                .o_stat_1(r_stat_out[2*i+1]),
                .o_valid_0(r_valid_out[2*i]),
                .o_valid_1(r_valid_out[2*i+1])
            );
        end
    endgenerate
    
endmodule
