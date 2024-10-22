`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 02:30:56 PM
// Design Name: 
// Module Name: chain_monitor
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


module chain_monitor #(
        parameter NODES         = 16,
        parameter ASSOC_W       = $clog2(NODES),
        parameter CRL_W         = 2*ASSOC_W+2,          // +2 for valid and switch_en bits
        parameter OUT_W         = ASSOC_W+2
    )(
        input wire  [CRL_W*NODES-1:0]       crl_in,
        input wire  [ASSOC_W-1:0]           base_chain_num,
        input wire  [ASSOC_W-1:0]           buddy_chain_num,
        
        output wire [OUT_W-1:0]             base_reply_out,
        output wire [OUT_W-1:0]             buddy_reply_out
    );
    
    localparam SWITCH_OFFSET            = 2*ASSOC_W;
    localparam VALID_OFFSET             = SWITCH_OFFSET+1;
    localparam SRC_OFFSET               = ASSOC_W;
    
    wire    [ASSOC_W-1:0]               src_assoc_unpkd[0:NODES-1];
    wire    [ASSOC_W-1:0]               dst_assoc_unpkd[0:NODES-1];
    wire    [NODES-1:0]                 assoc_valid;
    wire    [NODES-1:0]                 switch_en;
    wire                                base_reply_valid;
    wire                                buddy_reply_valid;
    
    reg     [NODES-1:0]                 base_bit_mask;
    reg     [NODES-1:0]                 buddy_bit_mask;
    reg     [ASSOC_W-1:0]               base_reply_sel;
    reg     [ASSOC_W-1:0]               buddy_reply_sel;
    
    assign base_reply_out = {base_reply_valid, switch_en[base_reply_sel], src_assoc_unpkd[base_reply_sel]};
    assign buddy_reply_out = {buddy_reply_valid, switch_en[buddy_reply_sel], src_assoc_unpkd[buddy_reply_sel]};
    
    genvar i;
    integer j;
    
    assign base_reply_valid = (base_bit_mask) ? 1'b1 : 1'b0;
    assign buddy_reply_valid = (buddy_bit_mask) ? 1'b1 : 1'b0;
    
    generate
        for (i = 0; i < NODES; i = i+1) begin
            assign dst_assoc_unpkd[i] = crl_in[i*CRL_W +: ASSOC_W];
            assign src_assoc_unpkd[i] = crl_in[i*CRL_W+SRC_OFFSET +: ASSOC_W];
            assign switch_en[i] = crl_in[i*CRL_W+SWITCH_OFFSET];
            assign assoc_valid[i] = crl_in[i*CRL_W+VALID_OFFSET];
        end
    endgenerate
    
    // Base Bitmask generator
    always @(*) begin
        for (j = 0; j < NODES; j = j+1) begin
            base_bit_mask[j] = (assoc_valid[j] && dst_assoc_unpkd[j] == base_chain_num) ? 1'b1 : 1'b0;
        end
    end
    // Buddy Bitmask generator
    always @(*) begin
        for (j = 0; j < NODES; j = j+1) begin
            buddy_bit_mask[j] = (assoc_valid[j] && dst_assoc_unpkd[j] == buddy_chain_num) ? 1'b1 : 1'b0;
        end
    end
    
    // Base Bitmask decoder
    always @(*) begin
        base_reply_sel = 0;
        for (j = 0; j < NODES; j = j+1) begin
            if (base_bit_mask[j]) base_reply_sel = j;
        end
    end
    // Buddy Bitmask decoder
    always @(*) begin
        buddy_reply_sel = 0;
        for (j = 0; j < NODES; j = j+1) begin
            if (buddy_bit_mask[j]) buddy_reply_sel = j;
        end
    end
    
endmodule
