`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 02:33:03 PM
// Design Name: 
// Module Name: assoc_manager
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


module assoc_manager #(
        parameter INPUTS        = 16,
        parameter NODES         = INPUTS/4,
        parameter ASSOC_W       = $clog2(NODES),
        parameter PACKET_W      = ASSOC_W+2,                    // +2 for valid and switch_en flags
        parameter REPLY_W       = 2*ASSOC_W+2,
        parameter ADDR_W        = $clog2(INPUTS)
    )(
        input wire                              stage_init,
        input wire                              init_base_scb,
        input wire                              init_buddy_scb,
        input wire                              cur_base_scb,
        input wire                              cur_buddy_scb,
        input wire  [ASSOC_W-1:0]               init_base_assoc,
        input wire  [ASSOC_W-1:0]               init_buddy_assoc,
        input wire  [PACKET_W-1:0]              base_reply_in,
        input wire  [PACKET_W-1:0]              base_collision_in,
        input wire  [PACKET_W-1:0]              buddy_reply_in,
        input wire  [PACKET_W-1:0]              buddy_collision_in,
        input wire  [ASSOC_W-1:0]               base_cur_assoc_num,
        input wire  [ASSOC_W-1:0]               buddy_cur_assoc_num,
        
        output wire                             base_scb_out,
        output wire                             buddy_scb_out,
        output wire [ASSOC_W-1:0]               base_assoc_out,
        output wire [REPLY_W-1:0]               base_reply_out,
        output wire [ASSOC_W-1:0]               buddy_assoc_out,
        output wire [REPLY_W-1:0]               buddy_reply_out
    );
    
    wire    [ASSOC_W-1:0]           base_assoc_drv;
    wire    [ASSOC_W-1:0]           buddy_assoc_drv;
    wire                            base_scb_switch_en;
    wire                            buddy_scb_switch_en;
    
    // Set mux outputs
    assign base_assoc_out = (stage_init) ? init_base_assoc : base_assoc_drv;
    assign buddy_assoc_out = (stage_init) ? init_buddy_assoc : buddy_assoc_drv;
    assign base_scb_out = (stage_init) ? init_base_scb^base_scb_switch_en : cur_base_scb^base_scb_switch_en;
    assign buddy_scb_out = (stage_init) ? init_buddy_scb^buddy_scb_switch_en : cur_buddy_scb^buddy_scb_switch_en;
        
    // Base Assoc comparator
    assoc_comparator #(
        .NODES(NODES),
        .ASSOC_W(ASSOC_W),
        .PACKET_W(PACKET_W),
        .REPLY_W(REPLY_W)
    ) base_comp_i (
        .collision_in(base_collision_in),
        .reply_in(base_reply_in),
        .cur_assoc_num(base_cur_assoc_num),
        
        .assoc_out(base_assoc_drv),
        .reply_out(base_reply_out),
        .switch_en_out(base_scb_switch_en)
    );
    // Buddy Assoc comparator
    assoc_comparator #(
        .NODES(NODES),
        .ASSOC_W(ASSOC_W),
        .PACKET_W(PACKET_W),
        .REPLY_W(REPLY_W)
    ) buddy_comp_i (
        .collision_in(buddy_collision_in),
        .reply_in(buddy_reply_in),
        .cur_assoc_num(buddy_cur_assoc_num),
        
        .assoc_out(buddy_assoc_drv),
        .reply_out(buddy_reply_out),
        .switch_en_out(buddy_scb_switch_en)
    );
        
endmodule
