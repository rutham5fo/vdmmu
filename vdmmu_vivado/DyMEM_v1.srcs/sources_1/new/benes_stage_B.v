`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:04:21 PM
// Design Name: 
// Module Name: benes_stage_B
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


module benes_stage_B #(
        parameter TEST_EN           = 0,
        parameter INPUTS            = 32,
        parameter NODES             = INPUTS/2,
        parameter ADDR_W            = $clog2(INPUTS),
        parameter STAGE_NUM         = 0,
        parameter STAGES            = $clog2(INPUTS)
    )(
        input wire                      clk,
        input wire                      reset_n,
        input wire                      scb_en,
        input wire  [ADDR_W*INPUTS-1:0] addr_in,
        input wire  [INPUTS-1:0]        valid_in,
        
        output wire [ADDR_W*INPUTS-1:0] addr_out,
        output wire [INPUTS-1:0]        valid_out,
        output wire [NODES-1:0]         scb_out
    );
    
    localparam SPLIT            = (STAGE_NUM < STAGES-1) ? 2**(STAGE_NUM+1) : 2**STAGE_NUM;
    
    wire    [ADDR_W-1:0]        addr_in_unpkd[0:INPUTS-1];
    wire    [ADDR_W-1:0]        i_addr_out[0:INPUTS-1];
    wire    [ADDR_W-1:0]        addr_out_unpkd[0:INPUTS-1];
    wire    [INPUTS-1:0]        i_valid_out;
    
    genvar i;
    
    // Test wires
    generate
        if (TEST_EN >= 2) begin                  : BENES_STAGE_B_TEST
            integer k;
            
            always @(*) begin
                $write("%t: STAGE[%0d] ||| addr_in = {|", $time, STAGE_NUM);
                for (k = 0; k < INPUTS; k = k+1) begin
                    $write(" [%0d](%0d, %0d) |", k, addr_in_unpkd[k], valid_in[k]);
                end
                $display("}");
                $write("%t: STAGE[%0d] ||| i_addr_out = {|", $time, STAGE_NUM);
                for (k = 0; k < INPUTS; k = k+1) begin
                    $write(" [%0d](%0d, %0d) |", k, i_addr_out[k], i_valid_out[k]);
                end
                $display("}");
                $write("%t: STAGE[%0d] ||| addr_out = {|", $time, STAGE_NUM);
                for (k = 0; k < INPUTS; k = k+1) begin
                    $write(" [%0d](%0d, %0d) |", k, addr_out_unpkd[k], valid_out[k]);
                end
                $display("}");
            end
        end
     endgenerate
    //--------------------------------------------
    
    // Packed to unpacked
    generate
        for (i = 0; i < INPUTS; i = i+1) begin
            assign addr_in_unpkd[i] = addr_in[i*ADDR_W +: ADDR_W];
            assign addr_out[i*ADDR_W +: ADDR_W] = addr_out_unpkd[i];
        end
    endgenerate
    
    // Stage output mapping
    generate      
        if (STAGE_NUM < STAGES-1) begin
            for (i = 0; i < INPUTS; i = i+1) begin
                if ((i/SPLIT)%2 == 0) begin
                    if (i%2 == 0) begin
                        assign addr_out_unpkd[i] = i_addr_out[i];
                        assign valid_out[i] = i_valid_out[i];
                    end
                    else begin
                        assign addr_out_unpkd[i] = i_addr_out[i+SPLIT-1];
                        assign valid_out[i] = i_valid_out[i+SPLIT-1];
                    end
                end
                else begin
                    if (i%2 == 0) begin
                        assign addr_out_unpkd[i] = i_addr_out[i-SPLIT+1];
                        assign valid_out[i] = i_valid_out[i-SPLIT+1];
                    end
                    else begin
                        assign addr_out_unpkd[i] = i_addr_out[i];
                        assign valid_out[i] = i_valid_out[i];
                    end
                end
            end
        end
        else begin
            for (i = 0; i < INPUTS; i = i+1) begin
                if (i < SPLIT) begin
                    assign addr_out_unpkd[i] = i_addr_out[2*i];
                    assign valid_out[i] = i_valid_out[2*i];
                end
                else begin
                    assign addr_out_unpkd[i] = i_addr_out[2*(i-SPLIT)+1];
                    assign valid_out[i] = i_valid_out[2*(i-SPLIT)+1];
                end
            end
        end
    endgenerate
    
    // Node generation
    generate
        for (i = 0; i < NODES; i = i+1) begin
            benes_node_B #(
                .INPUTS(INPUTS),
                .NODES(NODES),
                .ADDR_W(ADDR_W),
                .STAGE_NUM(STAGE_NUM)
            ) benes_node_B_i (
                .clk(clk),
                .reset_n(reset_n),
                .scb_en(scb_en),
                .in_addr_0(addr_in_unpkd[2*i]),
                .in_addr_1(addr_in_unpkd[2*i+1]),
                .in_valid_0(valid_in[2*i]),
                .in_valid_1(valid_in[2*i+1]),
                
                .out_addr_0(i_addr_out[2*i]),
                .out_addr_1(i_addr_out[2*i+1]),
                .out_valid_0(i_valid_out[2*i]),
                .out_valid_1(i_valid_out[2*i+1]),
                .out_scb(scb_out[i])
            );
        end
    endgenerate
    
endmodule
