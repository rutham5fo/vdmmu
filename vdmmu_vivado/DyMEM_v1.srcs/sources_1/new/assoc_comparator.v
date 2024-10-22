`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 02:32:06 PM
// Design Name: 
// Module Name: assoc_comparator
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


module assoc_comparator #(
        parameter NODES             = 16,
        parameter ASSOC_W           = $clog2(NODES),
        parameter PACKET_W          = ASSOC_W+2,
        parameter REPLY_W           = 2*ASSOC_W+2
    )(
        input wire  [PACKET_W-1:0]      collision_in,
        input wire  [PACKET_W-1:0]      reply_in,
        input wire  [ASSOC_W-1:0]       cur_assoc_num,
        
        output wire [ASSOC_W-1:0]       assoc_out,
        output wire [REPLY_W-1:0]       reply_out,
        output wire                     switch_en_out
    );
        
    wire                            colin_valid;
    wire                            repin_valid;
    wire                            colin_switch;
    wire                            repin_switch;
    wire    [ASSOC_W-1:0]           colin_assoc;
    wire    [ASSOC_W-1:0]           repin_assoc;
    wire    [1:0]                   rep_sel;
    
    reg                             g_rep_valid;
    reg                             g_rep_switch;
    reg     [ASSOC_W-1:0]           g_rep_assoc;
    reg     [ASSOC_W-1:0]           assoc_drv;
    reg                             switch_en_drv;
    
    assign colin_valid = collision_in[PACKET_W-1];
    assign repin_valid = reply_in[PACKET_W-1];
    assign colin_switch = collision_in[PACKET_W-2];
    assign repin_switch = reply_in[PACKET_W-2];
    assign colin_assoc = collision_in[0 +: ASSOC_W];
    assign repin_assoc = reply_in[0 +: ASSOC_W];
    assign rep_sel = {repin_valid, colin_valid};
    
    assign assoc_out = assoc_drv;
    assign reply_out = {g_rep_valid, g_rep_switch, assoc_drv, g_rep_assoc};
    assign switch_en_out = switch_en_drv;
    
    always @(*) begin
        case(rep_sel)
            1       : begin
                g_rep_valid = 1'b1;
                g_rep_switch = colin_switch;
                g_rep_assoc = cur_assoc_num;
                assoc_drv = colin_assoc;
                switch_en_drv = colin_switch;
            end
            3       : begin
                g_rep_valid = (colin_assoc != repin_assoc) ? 1'b1 : 1'b0;
                g_rep_switch = repin_switch^colin_switch;
                g_rep_assoc = (repin_assoc > colin_assoc) ? repin_assoc : colin_assoc;
                assoc_drv = (repin_assoc < colin_assoc) ? repin_assoc : colin_assoc;
                switch_en_drv = (repin_assoc < colin_assoc) ? repin_switch : colin_switch;
            end
            default : begin
                g_rep_valid = 1'b0;
                g_rep_switch = 1'b0;
                g_rep_assoc = 0;
                assoc_drv = (repin_valid) ? repin_assoc : cur_assoc_num;
                switch_en_drv = (repin_valid) ? repin_switch : 1'b0;
            end
        endcase
    end
    
endmodule
