`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:00:31 PM
// Design Name: 
// Module Name: benes_block_A
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


module benes_block_A #(
        // Test param
        parameter TEST_EN       = 0,
        parameter BLOCK_NUM     = 0,
        //---------------------------
        parameter STAGE_NUM     = 0,
        parameter INPUTS        = 16,
        parameter SUB_NODES     = INPUTS/2,
        parameter SUP_NODES     = INPUTS/4,
        parameter ADDR_W        = $clog2(INPUTS),
        parameter STAGE_ADDR_W  = ADDR_W-1,
        parameter STAGES        = $clog2(SUB_NODES)
    )(
        input wire                              clk,
        input wire                              reset_n,
        input wire                              stage_init,
        input wire  [ADDR_W*INPUTS-1:0]         addr_in,
        input wire  [STAGE_ADDR_W*INPUTS-1:0]   stage_addr_in,
        input wire  [INPUTS-1:0]                addr_valid_in,
        
        output wire [ADDR_W*INPUTS-1:0]         addr_out,
        output wire [INPUTS-1:0]                addr_valid_out,
        output wire [SUB_NODES-1:0]             scb_out
    );
    
    localparam SUP_NODE_W           = (SUP_NODES != 1) ? $clog2(SUP_NODES) : 1;
    localparam SUB_NODE_W           = $clog2(SUB_NODES);
    localparam SPLIT                = INPUTS/2;
    localparam REPLY_W              = 2*SUP_NODE_W+2;
    
    wire    [ADDR_W-1:0]                addr_in_unpkd[0:INPUTS-1];
    wire    [INPUTS-1:0]                i_valid_out;
    wire    [ADDR_W-1:0]                i_addr_out[0:INPUTS-1];
    wire    [ADDR_W-1:0]                addr_out_unpkd[0:INPUTS-1];
    wire    [SUB_NODES-1:0]             scb_drv;
    wire    [SUP_NODE_W-1:0]            assoc_drv[0:SUB_NODES-1];
    wire    [REPLY_W-1:0]               reply_drv[0:SUB_NODES-1];
    //wire    [SUP_NODE_W*SUB_NODES-1:0]  assoc_regs_pckd;
    ///wire    [REPLY_W*SUB_NODES-1:0]     reply_regs_pckd;
    
    wire    [SUP_NODE_W*SUP_NODES-1:0]      r_assoc_even;
    wire    [SUP_NODE_W*SUP_NODES-1:0]      r_assoc_odd;
    wire    [REPLY_W*SUP_NODES-1:0]         r_reply_even;
    wire    [REPLY_W*SUP_NODES-1:0]         r_reply_odd;
    wire    [STAGE_ADDR_W*SUB_NODES-1:0]    r_stage_even;
    wire    [STAGE_ADDR_W*SUB_NODES-1:0]    r_stage_odd;
    wire    [SUB_NODES-1:0]                 r_stage_even_valid;
    wire    [SUB_NODES-1:0]                 r_stage_odd_valid;
    wire    [SUP_NODES-1:0]                 r_scb_even;
    wire    [SUP_NODES-1:0]                 r_scb_odd;
    
    reg     [SUB_NODES-1:0]             scb_regs;
    reg     [SUP_NODE_W-1:0]            assoc_regs[0:SUB_NODES-1];
    reg     [REPLY_W-1:0]               reply_regs[0:SUB_NODES-1];
    reg                                 stage_init_reg;
    
    genvar i;
    integer j;
    
    // Test wires
    generate
        if (TEST_EN >= 2) begin                 : BENES_BLOCK_TEST
            wire    [STAGE_ADDR_W-1:0]          block_addr_in_unpkd[0:INPUTS-1];
            wire    [STAGE_ADDR_W-1:0]          block_addr_out_unpkd[0:INPUTS-1];
            
            for (i = 0; i < SUB_NODES; i = i+1) begin
                assign block_addr_in_unpkd[2*i] = addr_in[(2*i)*ADDR_W +: STAGE_ADDR_W];
                assign block_addr_in_unpkd[2*i+1] = addr_in[(2*i+1)*ADDR_W +: STAGE_ADDR_W];
                assign block_addr_out_unpkd[2*i] = addr_out_unpkd[2*i][0 +: STAGE_ADDR_W];
                assign block_addr_out_unpkd[2*i+1] = addr_out_unpkd[2*i+1][0 +: STAGE_ADDR_W];
            end
            
            always @(negedge clk) begin
                $write("%t: STAGE[%0d] ||| BLOCK[%0d] || stage_inputs = {|", $time, STAGE_NUM, BLOCK_NUM);
                for (j = 0; j < INPUTS; j = j+1) begin
                    $write(" [%0d](%0d, %0d) |", j, addr_in_unpkd[j], addr_valid_in[j]);
                end
                $display(" }");
                $write("%t: STAGE[%0d] ||| BLOCK[%0d] || block_inputs = {|", $time, STAGE_NUM, BLOCK_NUM);
                for (j = 0; j < INPUTS; j = j+1) begin
                    $write(" [%0d](%0d, %0d) |", j, block_addr_in_unpkd[j], addr_valid_in[j]);
                end
                $display(" }");
                $write("%t: STAGE[%0d] ||| BLOCK[%0d] || stage_outputs = {", $time, STAGE_NUM, BLOCK_NUM);
                for (j = 0; j < INPUTS; j = j+1) begin
                    $write(" [%0d](%0d, %0d) |", j, block_addr_out_unpkd[j], addr_valid_out[j]);
                end
                $display(" }");
                $write("%t: STAGE[%0d] ||| BLOCK[%0d] || next_stage_inputs = {", $time, STAGE_NUM, BLOCK_NUM);
                for (j = 0; j < INPUTS; j = j+1) begin
                    $write(" [%0d](%0d, %0d) |", j, block_addr_out_unpkd[j][0 +: STAGE_ADDR_W-1], addr_valid_out[j]);
                end
                $display(" }");
            end
        end
    endgenerate
    //-------------------------------------------
    
    assign scb_out = scb_regs;
    
    generate
        for (i = 0; i < INPUTS; i = i+1) begin
            assign addr_in_unpkd[i] = addr_in[i*ADDR_W +: ADDR_W];
            assign addr_out[i*ADDR_W +: ADDR_W] = addr_out_unpkd[i];
        end
    endgenerate
    
    // Block output mapping
    generate
        for (i = 0; i < INPUTS; i = i+1) begin
            if ((i/SPLIT)%2 == 0) begin
                if (i%2 == 0) begin
                    assign addr_out_unpkd[i] = i_addr_out[i];
                    assign addr_valid_out[i] = i_valid_out[i];
                end
                else begin
                    assign addr_out_unpkd[i] = i_addr_out[i+SPLIT-1];
                    assign addr_valid_out[i] = i_valid_out[i+SPLIT-1];
                end
            end
            else begin
                if (i%2 == 0) begin
                    assign addr_out_unpkd[i] = i_addr_out[i-SPLIT+1];
                    assign addr_valid_out[i] = i_valid_out[i-SPLIT+1];
                end
                else begin
                    assign addr_out_unpkd[i] = i_addr_out[i];
                    assign addr_valid_out[i] = i_valid_out[i];
                end
            end
        end
    endgenerate
        
    //generate
    //    for (i = 0; i < SUB_NODES; i = i+1) begin
    //        assign assoc_regs_pckd[i*SUB_NODE_W +: SUB_NODE_W] = assoc_regs[i];
    //        assign reply_regs_pckd[i*REPLY_W +: REPLY_W] = reply_regs[i];
    //    end
    //endgenerate
    
    generate
        for (i = 0; i < SUP_NODES; i = i+1) begin
            assign r_assoc_even[i*SUP_NODE_W +: SUP_NODE_W] = assoc_regs[2*i];
            assign r_assoc_odd[i*SUP_NODE_W +: SUP_NODE_W] = assoc_regs[2*i+1];
            assign r_reply_even[i*REPLY_W +: REPLY_W] = reply_regs[2*i];
            assign r_reply_odd[i*REPLY_W +: REPLY_W] = reply_regs[2*i+1];
            assign r_stage_even[(2*i)*STAGE_ADDR_W +: STAGE_ADDR_W] = stage_addr_in[(4*i)*STAGE_ADDR_W +: STAGE_ADDR_W];
            assign r_stage_even[(2*i+1)*STAGE_ADDR_W +: STAGE_ADDR_W] = stage_addr_in[(4*i+1)*STAGE_ADDR_W +: STAGE_ADDR_W];
            assign r_stage_odd[(2*i)*STAGE_ADDR_W +: STAGE_ADDR_W] = stage_addr_in[(4*i+2)*STAGE_ADDR_W +: STAGE_ADDR_W];
            assign r_stage_odd[(2*i+1)*STAGE_ADDR_W +: STAGE_ADDR_W] = stage_addr_in[(4*i+3)*STAGE_ADDR_W +: STAGE_ADDR_W];
            assign r_stage_even_valid[2*i] = addr_valid_in[4*i];
            assign r_stage_even_valid[2*i+1] = addr_valid_in[4*i+1];
            assign r_stage_odd_valid[2*i] = addr_valid_in[4*i+2];
            assign r_stage_odd_valid[2*i+1] = addr_valid_in[4*i+3];
            assign r_scb_even[i] = scb_regs[2*i];
            assign r_scb_odd[i] = scb_regs[2*i+1];
        end
    endgenerate
    
    generate
        for (i = 0; i < SUP_NODES; i = i+1) begin
            localparam even_odd_base = i/2;
            localparam even_odd = i%2;
            if (even_odd) begin
                benes_node_A #(
                    .INPUTS(INPUTS/2),
                    .SUB_NODES(SUB_NODES/2),
                    .SUP_NODES(SUP_NODES/2),
                    .BASE_NUM(even_odd_base),
                    .STAGE_NUM(STAGE_NUM),
                    .ASSOC_W(SUP_NODE_W),
                    .ADDR_W(ADDR_W),
                    .REPLY_W(REPLY_W),
                    .STAGE_ADDR_W(STAGE_ADDR_W),
                    .STAGES(STAGES)
                ) sup_node_A_i (
                    .clk(clk),
                    //.reset_n(reset_n),
                    .reset_n(~stage_init),
                    .stage_init(stage_init_reg),
                    .scb_in(r_scb_odd),
                    .assoc_in(r_assoc_odd),
                    .reply_in(r_reply_odd),
                    .base_addr_0_in(addr_in_unpkd[2*i]),
                    .base_addr_1_in(addr_in_unpkd[2*i+1]),
                    .buddy_addr_0_in(addr_in_unpkd[2*i+SPLIT]),
                    .buddy_addr_1_in(addr_in_unpkd[2*i+1+SPLIT]),
                    .base_valid_0_in(addr_valid_in[2*i]),
                    .base_valid_1_in(addr_valid_in[2*i+1]),
                    .buddy_valid_0_in(addr_valid_in[2*i+SPLIT]),
                    .buddy_valid_1_in(addr_valid_in[2*i+1+SPLIT]),
                    .stage_addr_in(r_stage_odd),
                    .stage_valid_in(r_stage_odd_valid),
                    
                    .base_addr_0_out(i_addr_out[2*i]),
                    .base_addr_1_out(i_addr_out[2*i+1]),
                    .buddy_addr_0_out(i_addr_out[2*i+SPLIT]),
                    .buddy_addr_1_out(i_addr_out[2*i+1+SPLIT]),
                    .base_valid_0_out(i_valid_out[2*i]),
                    .base_valid_1_out(i_valid_out[2*i+1]),
                    .buddy_valid_0_out(i_valid_out[2*i+SPLIT]),
                    .buddy_valid_1_out(i_valid_out[2*i+1+SPLIT]),
                    .base_scb_out(scb_drv[i]),
                    .buddy_scb_out(scb_drv[i+SUP_NODES]),
                    .base_assoc_out(assoc_drv[i]),
                    .buddy_assoc_out(assoc_drv[i+SUP_NODES]),
                    .base_reply_out(reply_drv[i]),
                    .buddy_reply_out(reply_drv[i+SUP_NODES])
                );
            end
            else begin
                benes_node_A #(
                    .INPUTS(INPUTS/2),
                    .SUB_NODES(SUB_NODES/2),
                    .SUP_NODES(SUP_NODES/2),
                    .BASE_NUM(even_odd_base),
                    .STAGE_NUM(STAGE_NUM),
                    .ASSOC_W(SUP_NODE_W),
                    .ADDR_W(ADDR_W),
                    .REPLY_W(REPLY_W),
                    .STAGE_ADDR_W(STAGE_ADDR_W),
                    .STAGES(STAGES)
                ) sup_node_A_i (
                    .clk(clk),
                    //.reset_n(reset_n),
                    .reset_n(~stage_init),
                    .stage_init(stage_init_reg),
                    .scb_in(r_scb_even),
                    .assoc_in(r_assoc_even),
                    .reply_in(r_reply_even),
                    .base_addr_0_in(addr_in_unpkd[2*i]),
                    .base_addr_1_in(addr_in_unpkd[2*i+1]),
                    .buddy_addr_0_in(addr_in_unpkd[2*i+SPLIT]),
                    .buddy_addr_1_in(addr_in_unpkd[2*i+1+SPLIT]),
                    .base_valid_0_in(addr_valid_in[2*i]),
                    .base_valid_1_in(addr_valid_in[2*i+1]),
                    .buddy_valid_0_in(addr_valid_in[2*i+SPLIT]),
                    .buddy_valid_1_in(addr_valid_in[2*i+1+SPLIT]),
                    .stage_addr_in(r_stage_even),
                    .stage_valid_in(r_stage_even_valid),
                    
                    .base_addr_0_out(i_addr_out[2*i]),
                    .base_addr_1_out(i_addr_out[2*i+1]),
                    .buddy_addr_0_out(i_addr_out[2*i+SPLIT]),
                    .buddy_addr_1_out(i_addr_out[2*i+1+SPLIT]),
                    .base_valid_0_out(i_valid_out[2*i]),
                    .base_valid_1_out(i_valid_out[2*i+1]),
                    .buddy_valid_0_out(i_valid_out[2*i+SPLIT]),
                    .buddy_valid_1_out(i_valid_out[2*i+1+SPLIT]),
                    .base_scb_out(scb_drv[i]),
                    .buddy_scb_out(scb_drv[i+SUP_NODES]),
                    .base_assoc_out(assoc_drv[i]),
                    .buddy_assoc_out(assoc_drv[i+SUP_NODES]),
                    .base_reply_out(reply_drv[i]),
                    .buddy_reply_out(reply_drv[i+SUP_NODES])
                );
            end
        end
    endgenerate
    
    always @(posedge clk) begin
        if (!reset_n || stage_init) begin
            for (j = 0; j < SUB_NODES; j = j+1) begin
                assoc_regs[j] <= #1 j;
                reply_regs[j] <= #1 0;
                scb_regs[j] <= #1 1'b0;
            end
        end
        else begin
            for (j = 0; j < SUB_NODES; j = j+1) begin
                assoc_regs[j] <= #1 assoc_drv[j];
                reply_regs[j] <= #1 reply_drv[j];
                scb_regs[j] <= #1 scb_drv[j];
            end
        end
    end
    
    always @(posedge clk) begin
        stage_init_reg <= #1 (reset_n) ? stage_init : 1'b0;
    end
    
endmodule
