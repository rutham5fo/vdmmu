`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:01:12 PM
// Design Name: 
// Module Name: benes_stage_A
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


module benes_stage_A #(
        parameter TEST_EN       = 0,
        parameter INPUTS        = 32,
        parameter SUB_NODES     = INPUTS/2,
        parameter STAGE_NUM     = 0,
        parameter ADDR_W        = $clog2(INPUTS),
        parameter STAGES        = $clog2(SUB_NODES)
    )(
        input wire                          clk,
        input wire                          reset_n,
        input wire                          prev_stage_done,
        input wire  [ADDR_W*INPUTS-1:0]     addr_in,
        input wire  [INPUTS-1:0]            addr_valid_in,
        
        output wire                         stage_done,
        output wire [ADDR_W*INPUTS-1:0]     addr_out,
        output wire [INPUTS-1:0]            addr_valid_out,
        output wire [SUB_NODES-1:0]         scb_out
    );
    
    localparam BLOCK_COUNT          = SUB_NODES >> (STAGES-STAGE_NUM+1);
    localparam BLOCK_SUB_NODES      = SUB_NODES >> STAGE_NUM;
    localparam BLOCK_SUP_NODES      = BLOCK_SUB_NODES/2;
    localparam BLOCK_INPUTS         = BLOCK_SUB_NODES*2;
    localparam STAGE_ADDR_W         = ADDR_W-STAGE_NUM-1;
    
    localparam STAGE_COUNT          = $clog2(BLOCK_SUB_NODES);        // +1 for reply and init bias
    localparam STAGE_COUNT_W        = $clog2(STAGE_COUNT)+1;
    
    wire    [ADDR_W-1:0]                    addr_in_unpkd[0:INPUTS-1];
    wire    [ADDR_W*BLOCK_INPUTS-1:0]       block_addr_in[0:BLOCK_COUNT-1];
    wire    [ADDR_W*BLOCK_INPUTS-1:0]       block_addr_out[0:BLOCK_COUNT-1];
    //wire    [STAGE_ADDR_W-1:0]              stage_addr_unpkd[0:INPUTS-1];
    wire    [STAGE_ADDR_W*BLOCK_INPUTS-1:0] block_stage_addr[0:BLOCK_COUNT-1];
    wire    [BLOCK_INPUTS-1:0]              block_valid_in[0:BLOCK_COUNT-1];
    wire    [BLOCK_INPUTS-1:0]              block_valid_out[0:BLOCK_COUNT-1];
    wire    [BLOCK_SUB_NODES-1:0]           block_scb_out[0:BLOCK_COUNT-1];
    
    reg     [STAGE_COUNT_W-1:0]             stage_counter;
    reg     [ADDR_W-1:0]                    addr_in_regs[0:INPUTS-1];
    reg     [STAGE_ADDR_W-1:0]              stage_addr_regs[0:INPUTS-1];
    reg     [INPUTS-1:0]                    addr_valid_in_regs;
    
    genvar i, j;
    integer k;
    
    assign stage_done = (stage_counter == STAGE_COUNT-1) ? 1'b1 : 1'b0;
    
    generate
        for (i = 0; i < INPUTS; i = i+1) begin
            assign addr_in_unpkd[i] = addr_in[i*ADDR_W +: ADDR_W];
            //assign stage_addr_unpkd[i] = addr_in_regs[i][0 +: STAGE_ADDR_W];
        end
    endgenerate
    
    generate
        for (i = 0; i < BLOCK_COUNT; i = i+1) begin
            localparam BLOCK_START = BLOCK_INPUTS*i;
            assign addr_out[BLOCK_START*ADDR_W +: ADDR_W*BLOCK_INPUTS] = block_addr_out[i];
            assign addr_valid_out[BLOCK_START +: BLOCK_INPUTS] = block_valid_out[i];
        end
    endgenerate
    
    generate
        for (i = 0; i < BLOCK_COUNT; i = i+1) begin
            localparam BLOCK_START = BLOCK_INPUTS*i;
            for (j = 0; j < BLOCK_INPUTS; j = j+1) begin
                assign block_addr_in[i][j*ADDR_W +: ADDR_W] = addr_in_regs[BLOCK_START+j];
                assign block_valid_in[i][j] = addr_valid_in_regs[BLOCK_START+j];
                //assign block_stage_addr[i][j*STAGE_ADDR_W +: STAGE_ADDR_W] = stage_addr_unpkd[BLOCK_START+j];
                assign block_stage_addr[i][j*STAGE_ADDR_W +: STAGE_ADDR_W] = stage_addr_regs[BLOCK_START+j];
            end
        end
    endgenerate
    
    generate
        for (i = 0; i < BLOCK_COUNT; i = i+1) begin
            localparam BLOCK_START = BLOCK_SUB_NODES*i;
            for (j = 0; j < BLOCK_SUB_NODES; j = j+1) begin
                assign scb_out[BLOCK_START+j] = block_scb_out[i][j];
            end
        end
    endgenerate
    
    generate
        for (i = 0; i < BLOCK_COUNT; i = i+1) begin
            benes_block_A #(
                // Test param
                .TEST_EN(TEST_EN),
                .BLOCK_NUM(i),
                //---------------------------
                .STAGE_NUM(STAGE_NUM),
                .INPUTS(BLOCK_INPUTS),
                .SUB_NODES(BLOCK_SUB_NODES),
                .SUP_NODES(BLOCK_SUP_NODES),
                .ADDR_W(ADDR_W),
                .STAGE_ADDR_W(STAGE_ADDR_W),
                .STAGES(STAGES)
            ) block_A_i (
                .clk(clk),
                .reset_n(reset_n),
                .stage_init(prev_stage_done),
                .addr_in(block_addr_in[i]),
                .stage_addr_in(block_stage_addr[i]),
                .addr_valid_in(block_valid_in[i]),
        
                .addr_out(block_addr_out[i]),
                .addr_valid_out(block_valid_out[i]),
                .scb_out(block_scb_out[i])
            );
        end
    endgenerate
    
    always @(posedge clk) begin
        if (!reset_n) addr_valid_in_regs <= #1 0;
        else addr_valid_in_regs <= #1 (prev_stage_done) ? addr_valid_in : addr_valid_in_regs;
    end
    
    always @(posedge clk) begin
        if (!reset_n) begin
            for (k = 0; k < INPUTS; k = k+1) begin
                addr_in_regs[k] <= #1 0;
                stage_addr_regs[k] <= #1 0;
            end
        end
        else begin
            for (k = 0; k < INPUTS; k = k+1) begin
                addr_in_regs[k] <= #1 (prev_stage_done) ? addr_in_unpkd[k] : addr_in_regs[k];
                stage_addr_regs[k] <= #1 (prev_stage_done) ? addr_in_unpkd[k][0 +: STAGE_ADDR_W] : stage_addr_regs[k];
            end
        end
    end
    
    always @(posedge clk) begin
        if (!reset_n) begin
            stage_counter <= #1 STAGE_COUNT;
        end
        else begin
            if (prev_stage_done) stage_counter <= #1 0;
            else stage_counter <= #1 (stage_counter < STAGE_COUNT) ? stage_counter+1 : stage_counter;
        end
    end
    
endmodule
