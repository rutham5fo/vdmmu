`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 11:59:47 AM
// Design Name: 
// Module Name: benes_node_A
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


module benes_node_A #(
        parameter INPUTS        = 32,
        parameter SUB_NODES     = INPUTS/2,
        parameter SUP_NODES     = INPUTS/4,
        parameter BASE_NUM      = 0,
        parameter STAGE_NUM     = 0,
        parameter ASSOC_W       = $clog2(SUB_NODES),
        parameter ADDR_W        = $clog2(INPUTS),
        parameter REPLY_W       = 2*ASSOC_W+2,
        parameter STAGE_ADDR_W  = ADDR_W-1,
        parameter STAGES        = $clog2(SUB_NODES)
    )(
        input wire                              clk,
        input wire                              reset_n,
        input wire                              stage_init,
        input wire  [SUB_NODES-1:0]             scb_in,
        input wire  [ASSOC_W*SUB_NODES-1:0]     assoc_in,
        input wire  [REPLY_W*SUB_NODES-1:0]     reply_in,
        input wire  [ADDR_W-1:0]                base_addr_0_in,
        input wire  [ADDR_W-1:0]                base_addr_1_in,
        input wire  [ADDR_W-1:0]                buddy_addr_0_in,
        input wire  [ADDR_W-1:0]                buddy_addr_1_in,
        input wire  [STAGE_ADDR_W*INPUTS-1:0]   stage_addr_in,
        input wire  [INPUTS-1:0]                stage_valid_in,
        input wire                              base_valid_0_in,
        input wire                              base_valid_1_in,
        input wire                              buddy_valid_0_in,
        input wire                              buddy_valid_1_in,
        
        output wire [ADDR_W-1:0]                base_addr_0_out,
        output wire [ADDR_W-1:0]                base_addr_1_out,
        output wire [ADDR_W-1:0]                buddy_addr_0_out,
        output wire [ADDR_W-1:0]                buddy_addr_1_out,
        output wire                             base_valid_0_out,
        output wire                             base_valid_1_out,
        output wire                             buddy_valid_0_out,
        output wire                             buddy_valid_1_out,
        output wire                             base_scb_out,
        output wire                             buddy_scb_out,
        output wire [ASSOC_W-1:0]               base_assoc_out,
        output wire [REPLY_W-1:0]               base_reply_out,
        output wire [ASSOC_W-1:0]               buddy_assoc_out,
        output wire [REPLY_W-1:0]               buddy_reply_out
    );
    
    localparam SUB_SPLIT            = SUB_NODES/2;
    localparam BUDDY_NUM            = BASE_NUM+SUB_SPLIT;
    localparam PACKET_W             = ASSOC_W+2;
    
    wire    [STAGE_ADDR_W*SUB_NODES-1:0]    stage_addr_0;
    wire    [STAGE_ADDR_W*SUB_NODES-1:0]    stage_addr_1;
    //wire    [STAGE_ADDR_W-1:0]            stage_addr_0_unpkd[0:INPUTS-1];
    //wire    [STAGE_ADDR_W-1:0]            stage_addr_1_unpkd[0:INPUTS-1];
    wire    [SUB_NODES-1:0]                 stage_valid_0;
    wire    [SUB_NODES-1:0]                 stage_valid_1;
        
    // Base
    wire                                init_base_scb;
    wire                                cur_base_scb;
    wire    [ASSOC_W-1:0]               init_base_assoc;
    wire    [ASSOC_W-1:0]               base_cur_assoc;
    wire    [PACKET_W-1:0]              base_col_detected;
    wire    [PACKET_W-1:0]              base_rep_detected;
    
    // Buddy
    wire                                init_buddy_scb;
    wire                                cur_buddy_scb;
    wire    [ASSOC_W-1:0]               init_buddy_assoc;
    wire    [ASSOC_W-1:0]               buddy_cur_assoc;
    wire    [PACKET_W-1:0]              buddy_col_detected;
    wire    [PACKET_W-1:0]              buddy_rep_detected;
    
    genvar i;
    
    generate
        for (i = 0; i < SUB_NODES; i = i+1) begin
            assign stage_addr_0[i*STAGE_ADDR_W +: STAGE_ADDR_W] = stage_addr_in[2*i*STAGE_ADDR_W +: STAGE_ADDR_W];
            assign stage_addr_1[i*STAGE_ADDR_W +: STAGE_ADDR_W] = stage_addr_in[(2*i+1)*STAGE_ADDR_W +: STAGE_ADDR_W];
            assign stage_valid_0[i] = stage_valid_in[2*i];
            assign stage_valid_1[i] = stage_valid_in[2*i+1];
        end
    endgenerate
        
    // Node initializer
    node_init #(
        .INPUTS(INPUTS),
        .BASE_NUM(BASE_NUM),
        .BUDDY_NUM(BUDDY_NUM),
        .STAGE_NUM(STAGE_NUM),
        .ADDR_W(ADDR_W),
        .ASSOC_W(ASSOC_W),
        .STAGE_ADDR_W(STAGE_ADDR_W),
        .STAGES(STAGES)
    ) node_init_i (
        .base_addr_0_in(base_addr_0_in),
        .base_addr_1_in(base_addr_1_in),
        .buddy_addr_0_in(buddy_addr_0_in),
        .buddy_addr_1_in(buddy_addr_1_in),
        .base_valid_0_in(base_valid_0_in),
        .base_valid_1_in(base_valid_1_in),
        .buddy_valid_0_in(buddy_valid_0_in),
        .buddy_valid_1_in(buddy_valid_1_in),
        .cur_base_scb(cur_base_scb),
        .cur_buddy_scb(cur_buddy_scb),
        //.cur_base_scb(base_scb_out),
        //.cur_buddy_scb(buddy_scb_out),
        
        .base_addr_0_out(base_addr_0_out),
        .base_addr_1_out(base_addr_1_out),
        .buddy_addr_0_out(buddy_addr_0_out),
        .buddy_addr_1_out(buddy_addr_1_out),
        .base_valid_0_out(base_valid_0_out),
        .base_valid_1_out(base_valid_1_out),
        .buddy_valid_0_out(buddy_valid_0_out),
        .buddy_valid_1_out(buddy_valid_1_out),
        .init_base_assoc(init_base_assoc),
        .init_buddy_assoc(init_buddy_assoc),
        .init_base_scb(init_base_scb),
        .init_buddy_scb(init_buddy_scb)
    );
    
    // Super node colision finder
    collision_monitor #(
        .BASE_NUM(BASE_NUM),
        .BUDDY_NUM(BUDDY_NUM),
        .INPUTS(INPUTS),
        .NODES(SUB_NODES),
        .SUB_SPLIT(SUB_SPLIT),
        .SUP_NODES(SUP_NODES),
        .ADDR_W(STAGE_ADDR_W),
        .ASSOC_W(ASSOC_W),
        .PACKET_W(PACKET_W)
    ) collision_mon_i (
        .clk(clk),
        .reset_n(reset_n),
        .comp_addr_0(stage_addr_0),
        .comp_addr_1(stage_addr_1),
        .comp_valid_0(stage_valid_0),
        .comp_valid_1(stage_valid_1),
        .assoc_in(assoc_in),
        .scb_in(scb_in),
        
        .cur_base_scb(cur_base_scb),
        .cur_buddy_scb(cur_buddy_scb),
        .cur_base_assoc(base_cur_assoc),
        .cur_buddy_assoc(buddy_cur_assoc),
        .base_assoc_out(base_col_detected),
        .buddy_assoc_out(buddy_col_detected)
    );
    
    // Chain monitor
    chain_monitor #(
        .NODES(SUB_NODES),
        .ASSOC_W(ASSOC_W),
        .CRL_W(REPLY_W),
        .OUT_W(PACKET_W)
    ) chain_mon_i (
        .crl_in(reply_in),
        .base_chain_num(base_cur_assoc),
        .buddy_chain_num(buddy_cur_assoc),
        
        .base_reply_out(base_rep_detected),
        .buddy_reply_out(buddy_rep_detected)
    );
    
    // Node manager
    assoc_manager #(
        .INPUTS(INPUTS),
        .NODES(SUB_NODES),
        .ASSOC_W(ASSOC_W),
        .PACKET_W(PACKET_W),
        .REPLY_W(REPLY_W),
        .ADDR_W(ADDR_W)
    ) manager_i (
        .stage_init(stage_init),
        .init_base_scb(init_base_scb),
        .init_buddy_scb(init_buddy_scb),
        .cur_base_scb(cur_base_scb),
        .cur_buddy_scb(cur_buddy_scb),
        .init_base_assoc(init_base_assoc),
        .init_buddy_assoc(init_buddy_assoc),
        .base_reply_in(base_rep_detected),
        .base_collision_in(base_col_detected),
        .buddy_reply_in(buddy_rep_detected),
        .buddy_collision_in(buddy_col_detected),
        .base_cur_assoc_num(base_cur_assoc),
        .buddy_cur_assoc_num(buddy_cur_assoc),
        
        .base_scb_out(base_scb_out),
        .buddy_scb_out(buddy_scb_out),
        .base_assoc_out(base_assoc_out),
        .base_reply_out(base_reply_out),
        .buddy_assoc_out(buddy_assoc_out),
        .buddy_reply_out(buddy_reply_out)
    );
        
endmodule
