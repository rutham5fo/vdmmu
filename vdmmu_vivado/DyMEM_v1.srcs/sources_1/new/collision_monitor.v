`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 02:29:14 PM
// Design Name: 
// Module Name: collision_monitor
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


module collision_monitor #(
        parameter BASE_NUM      = 0,
        parameter BUDDY_NUM     = 4,
        parameter INPUTS        = 16,
        parameter NODES         = INPUTS/2,
        parameter SUB_SPLIT     = NODES/2,
        parameter SUP_NODES     = NODES/2,
        parameter ADDR_W        = $clog2(INPUTS),
        parameter ASSOC_W       = $clog2(NODES),
        parameter PACKET_W      = ASSOC_W+2                     // +2 = valid, switch flags
    )(
        input wire                          clk,
        input wire                          reset_n,
        input wire  [ADDR_W*NODES-1:0]      comp_addr_0,
        input wire  [ADDR_W*NODES-1:0]      comp_addr_1,
        input wire  [NODES-1:0]             comp_valid_0,
        input wire  [NODES-1:0]             comp_valid_1,
        input wire  [ASSOC_W*NODES-1:0]     assoc_in,
        input wire  [NODES-1:0]             scb_in,
        
        output wire                         cur_base_scb,
        output wire                         cur_buddy_scb,
        output wire [ASSOC_W-1:0]           cur_base_assoc,
        output wire [ASSOC_W-1:0]           cur_buddy_assoc,
        output wire [PACKET_W-1:0]          base_assoc_out,
        output wire [PACKET_W-1:0]          buddy_assoc_out
    );
    
    wire    [ASSOC_W-1:0]           assoc_unpkd[0:NODES-1];
        
    wire    [ADDR_W-1:0]            base_addr_0;
    wire    [ADDR_W-1:0]            base_addr_1;
    wire    [ADDR_W-1:0]            buddy_addr_0;
    wire    [ADDR_W-1:0]            buddy_addr_1;
    wire    [ADDR_W-1:0]            comp_addr_0_unpkd[0:NODES-1];
    wire    [ADDR_W-1:0]            comp_addr_1_unpkd[0:NODES-1];
    wire                            base_valid_0;
    wire                            base_valid_1;
    wire                            buddy_valid_0;
    wire                            buddy_valid_1;
    
    wire    [SUP_NODES-1:0]         base_0_v_comp_base;
    wire    [SUP_NODES-1:0]         base_0_v_comp_buddy;
    wire    [SUP_NODES-1:0]         base_0_v_comp_addr;
    wire    [SUP_NODES-1:0]         base_1_v_comp_base;
    wire    [SUP_NODES-1:0]         base_1_v_comp_buddy;
    wire    [SUP_NODES-1:0]         base_1_v_comp_addr;
    wire    [SUP_NODES-1:0]         base_sub_sel;
    wire    [SUP_NODES-1:0]         base_v_comp_base_switch_en;
    wire    [SUP_NODES-1:0]         base_v_comp_buddy_switch_en;
    wire    [SUP_NODES-1:0]         base_switch_en;
    wire    [SUP_NODES-1:0]         buddy_0_v_comp_base;
    wire    [SUP_NODES-1:0]         buddy_0_v_comp_buddy;
    wire    [SUP_NODES-1:0]         buddy_0_v_comp_addr;
    wire    [SUP_NODES-1:0]         buddy_1_v_comp_base;
    wire    [SUP_NODES-1:0]         buddy_1_v_comp_buddy;
    wire    [SUP_NODES-1:0]         buddy_1_v_comp_addr;
    wire    [SUP_NODES-1:0]         buddy_sub_sel;
    wire    [SUP_NODES-1:0]         buddy_v_comp_base_switch_en;
    wire    [SUP_NODES-1:0]         buddy_v_comp_buddy_switch_en;
    wire    [SUP_NODES-1:0]         buddy_switch_en;
    
    wire    [SUP_NODES-1:0]         base_mask;
    wire    [SUP_NODES-1:0]         buddy_mask;
    wire    [ASSOC_W-1:0]           base_neigh_assoc;
    wire    [ASSOC_W-1:0]           buddy_neigh_assoc;
    wire                            base_neigh_scb;
    wire                            buddy_neigh_scb;
    wire    [ASSOC_W-1:0]           base_col_sel;
    wire    [ASSOC_W-1:0]           buddy_col_sel;
    
    wire                            base_neigh_valid;
    wire                            buddy_neigh_valid;
    wire                            base_col_switch_en;
    wire                            buddy_col_switch_en;
    
    reg                             base_neigh_ext_drv;
    reg                             buddy_neigh_ext_drv;
    reg     [ASSOC_W-1:0]           base_neigh_sel_drv;
    reg     [ASSOC_W-1:0]           buddy_neigh_sel_drv;
    reg     [ASSOC_W-1:0]           base_neigh_sel;
    reg     [ASSOC_W-1:0]           buddy_neigh_sel;
    reg                             base_neigh_rel;
    reg                             buddy_neigh_rel;
    reg                             base_neigh_ext;
    reg                             buddy_neigh_ext;
    
    integer i;
    genvar j;
    
    generate
        for (j = 0; j < NODES; j = j+1) begin
            assign comp_addr_0_unpkd[j] = comp_addr_0[j*ADDR_W +: ADDR_W];
            assign comp_addr_1_unpkd[j] = comp_addr_1[j*ADDR_W +: ADDR_W];
        end
    endgenerate
    
    generate
        for (j = 0; j < NODES; j = j+1) begin
            assign assoc_unpkd[j] = assoc_in[j*ASSOC_W +: ASSOC_W];
        end
    endgenerate
    
    // Get cur_assoc and scbs
    assign cur_base_assoc = assoc_unpkd[BASE_NUM];
    assign cur_buddy_assoc = assoc_unpkd[BUDDY_NUM];
    assign cur_base_scb = scb_in[BASE_NUM];
    assign cur_buddy_scb = scb_in[BUDDY_NUM];
    
    // Get first valid addr (priority to addr_0)
    assign base_addr_0 = comp_addr_0_unpkd[BASE_NUM];
    assign base_addr_1 = comp_addr_1_unpkd[BASE_NUM];
    assign buddy_addr_0 = comp_addr_0_unpkd[BUDDY_NUM];
    assign buddy_addr_1 = comp_addr_1_unpkd[BUDDY_NUM];
    assign base_valid_0 = comp_valid_0[BASE_NUM];
    assign base_valid_1 = comp_valid_1[BASE_NUM];
    assign buddy_valid_0 = comp_valid_0[BUDDY_NUM];
    assign buddy_valid_1 = comp_valid_1[BUDDY_NUM];
    
    // Generate neighbour bit mask
    generate
        for (j = 0; j < SUP_NODES; j = j+1) begin
            if (j != BASE_NUM) begin
                // Base
                assign base_0_v_comp_base[j] = (base_valid_0 && ((comp_addr_0_unpkd[j] == base_addr_0 && comp_valid_0[j]) || (comp_addr_1_unpkd[j] == base_addr_0 && comp_valid_1[j]))) ? 1'b1 : 1'b0;
                assign base_0_v_comp_buddy[j] = (base_valid_0 && ((comp_addr_0_unpkd[j+SUB_SPLIT] == base_addr_0 && comp_valid_0[j+SUB_SPLIT]) || (comp_addr_1_unpkd[j+SUB_SPLIT] == base_addr_0 && comp_valid_1[j+SUB_SPLIT]))) ? 1'b1 : 1'b0;
                assign base_1_v_comp_base[j] = (base_valid_1 && ((comp_addr_0_unpkd[j] == base_addr_1 && comp_valid_0[j]) || (comp_addr_1_unpkd[j] == base_addr_1 && comp_valid_1[j]))) ? 1'b1 : 1'b0;
                assign base_1_v_comp_buddy[j] = (base_valid_1 && ((comp_addr_0_unpkd[j+SUB_SPLIT] == base_addr_1 && comp_valid_0[j+SUB_SPLIT]) || (comp_addr_1_unpkd[j+SUB_SPLIT] == base_addr_1 && comp_valid_1[j+SUB_SPLIT]))) ? 1'b1 : 1'b0;
                assign base_0_v_comp_addr[j] = (base_0_v_comp_base[j] || base_0_v_comp_buddy[j]) ? 1'b1 : 1'b0;
                assign base_1_v_comp_addr[j] = (base_1_v_comp_base[j] || base_1_v_comp_buddy[j]) ? 1'b1 : 1'b0;
                assign base_sub_sel[j] = (base_0_v_comp_buddy[j] || base_1_v_comp_buddy[j]) ? 1'b1 : 1'b0;
                assign base_v_comp_base_switch_en[j] = ((base_valid_0 && (comp_addr_0_unpkd[j] == base_addr_0 && comp_valid_0[j])) || (base_valid_1 && (comp_addr_1_unpkd[j] == base_addr_1 && comp_valid_1[j]))) ? 1'b1 :1'b0;
                assign base_v_comp_buddy_switch_en[j] = ((base_valid_0 && (comp_addr_0_unpkd[j+SUB_SPLIT] == base_addr_0 && comp_valid_0[j+SUB_SPLIT])) || (base_valid_1 && (comp_addr_1_unpkd[j+SUB_SPLIT] == base_addr_1 && comp_valid_1[j+SUB_SPLIT]))) ? 1'b1 :1'b0;
                // Buddy
                assign buddy_0_v_comp_base[j] = (buddy_valid_0 && ((comp_addr_0_unpkd[j] == buddy_addr_0 && comp_valid_0[j]) || (comp_addr_1_unpkd[j] == buddy_addr_0 && comp_valid_1[j]))) ? 1'b1 : 1'b0;
                assign buddy_0_v_comp_buddy[j] = (buddy_valid_0 && ((comp_addr_0_unpkd[j+SUB_SPLIT] == buddy_addr_0 && comp_valid_0[j+SUB_SPLIT]) || (comp_addr_1_unpkd[j+SUB_SPLIT] == buddy_addr_0 && comp_valid_1[j+SUB_SPLIT]))) ? 1'b1 : 1'b0;
                assign buddy_1_v_comp_base[j] = (buddy_valid_1 && ((comp_addr_0_unpkd[j] == buddy_addr_1 && comp_valid_0[j]) || (comp_addr_1_unpkd[j] == buddy_addr_1 && comp_valid_1[j]))) ? 1'b1 : 1'b0;
                assign buddy_1_v_comp_buddy[j] = (buddy_valid_1 && ((comp_addr_0_unpkd[j+SUB_SPLIT] == buddy_addr_1 && comp_valid_0[j+SUB_SPLIT]) || (comp_addr_1_unpkd[j+SUB_SPLIT] == buddy_addr_1 && comp_valid_1[j+SUB_SPLIT]))) ? 1'b1 : 1'b0;
                assign buddy_0_v_comp_addr[j] = (buddy_0_v_comp_base[j] || buddy_0_v_comp_buddy[j]) ? 1'b1 : 1'b0;
                assign buddy_1_v_comp_addr[j] = (buddy_1_v_comp_base[j] || buddy_1_v_comp_buddy[j]) ? 1'b1 : 1'b0;
                assign buddy_sub_sel[j] = (buddy_0_v_comp_buddy[j] || buddy_1_v_comp_buddy[j]) ? 1'b1 : 1'b0;
                assign buddy_v_comp_base_switch_en[j] = ((buddy_valid_0 && (comp_addr_0_unpkd[j] == buddy_addr_0 && comp_valid_0[j])) || (buddy_valid_1 && (comp_addr_1_unpkd[j] == buddy_addr_1 && comp_valid_1[j]))) ? 1'b1 :1'b0;
                assign buddy_v_comp_buddy_switch_en[j] = ((buddy_valid_0 && (comp_addr_0_unpkd[j+SUB_SPLIT] == buddy_addr_0 && comp_valid_0[j+SUB_SPLIT])) || (buddy_valid_1 && (comp_addr_1_unpkd[j+SUB_SPLIT] == buddy_addr_1 && comp_valid_1[j+SUB_SPLIT]))) ? 1'b1 :1'b0;
            end
            else begin
                // Base
                assign base_0_v_comp_base[j] = 1'b0;
                assign base_0_v_comp_buddy[j] = 1'b0;
                assign base_1_v_comp_base[j] = 1'b0;
                assign base_1_v_comp_buddy[j] = 1'b0;
                assign base_0_v_comp_addr[j] = 1'b0;
                assign base_1_v_comp_addr[j] = 1'b0;
                assign base_sub_sel[j] = 1'b0;
                assign base_v_comp_base_switch_en[j] = 1'b0;
                assign base_v_comp_buddy_switch_en[j] = 1'b0;
                // Buddy
                assign buddy_0_v_comp_base[j] = 1'b0;
                assign buddy_0_v_comp_buddy[j] = 1'b0;
                assign buddy_1_v_comp_base[j] = 1'b0;
                assign buddy_1_v_comp_buddy[j] = 1'b0;
                assign buddy_0_v_comp_addr[j] = 1'b0;
                assign buddy_1_v_comp_addr[j] = 1'b0;
                assign buddy_sub_sel[j] = 1'b0;
                assign buddy_v_comp_base_switch_en[j] = 1'b0;
                assign buddy_v_comp_buddy_switch_en[j] = 1'b0;
            end
        end
    endgenerate
    
    // Generate base_neighbour bitmask
    generate
        for (j = 0; j < SUP_NODES; j = j+1) begin
            if (j != BASE_NUM) begin
                assign base_mask[j] = (base_0_v_comp_addr[j] || base_1_v_comp_addr[j]) ? 1'b1 : 1'b0;
                assign base_switch_en[j] = (base_v_comp_base_switch_en[j] || base_v_comp_buddy_switch_en[j]) ? 1'b1 : 1'b0;
            end
            else begin
                assign base_mask[j] = 1'b0;
                assign base_switch_en[j] = 1'b0;
            end
        end
    endgenerate
    // Generate buddy_neighbour bitmask
    generate
        for (j = 0; j < SUP_NODES; j = j+1) begin
            if (j != BASE_NUM) begin
                assign buddy_mask[j] = (buddy_0_v_comp_addr[j] || buddy_1_v_comp_addr[j]) ? 1'b1 : 1'b0;
                assign buddy_switch_en[j] = (buddy_v_comp_base_switch_en[j] || buddy_v_comp_buddy_switch_en[j]) ? 1'b1 : 1'b0;
            end
            else begin
                assign buddy_mask[j] = 1'b0;
                assign buddy_switch_en[j] = 1'b0;
            end
        end
    endgenerate
    
    assign base_col_sel = {base_neigh_ext, base_neigh_sel};
    assign buddy_col_sel = {buddy_neigh_ext, buddy_neigh_sel};
    assign base_neigh_assoc = assoc_unpkd[base_col_sel];
    assign buddy_neigh_assoc = assoc_unpkd[buddy_col_sel];
    assign base_neigh_scb = scb_in[base_col_sel];
    assign buddy_neigh_scb = scb_in[buddy_col_sel];
    
    // ---------- Combit (dont_touch) ---------------
    assign base_assoc_out = {base_neigh_valid, base_col_switch_en, base_neigh_assoc};
    assign buddy_assoc_out = {buddy_neigh_valid, buddy_col_switch_en, buddy_neigh_assoc};
    
    assign base_neigh_valid = (base_neigh_assoc < cur_base_assoc && base_mask) ? 1'b1 : 1'b0;
    assign buddy_neigh_valid = (buddy_neigh_assoc < cur_buddy_assoc && buddy_mask) ? 1'b1 : 1'b0;
    assign base_col_switch_en = base_neigh_rel^(base_neigh_scb^cur_base_scb);
    assign buddy_col_switch_en = buddy_neigh_rel^(buddy_neigh_scb^cur_buddy_scb);
    // ----------------------------------------------
        
    // base bitmask decoder
    always @(*) begin
        base_neigh_sel_drv = 0;
        base_neigh_ext_drv = 1'b0;
        for (i = SUP_NODES-1; i >= 0; i = i-1) begin
            if (base_mask[i]) begin
                base_neigh_sel_drv = i;
                base_neigh_ext_drv = base_sub_sel[i];
            end
        end
    end
    // buddy bitmask decoder
    always @(*) begin
        buddy_neigh_sel_drv = 0;
        buddy_neigh_ext_drv = 0;
        for (i = SUP_NODES-1; i >= 0; i = i-1) begin
            if (buddy_mask[i]) begin
                buddy_neigh_sel_drv = i;
                buddy_neigh_ext_drv = buddy_sub_sel[i];
            end
        end
    end
    
    always @(posedge clk) begin
        if (!reset_n) begin
            base_neigh_ext <= 1'b0;
            buddy_neigh_ext <= 1'b0;
            base_neigh_sel <= BASE_NUM;
            buddy_neigh_sel <= BUDDY_NUM;
            base_neigh_rel <= 1'b0;
            buddy_neigh_rel <= 1'b0;
        end
        else begin
            base_neigh_ext <= base_neigh_ext_drv;
            buddy_neigh_ext <= buddy_neigh_ext_drv;
            base_neigh_sel <= base_neigh_sel_drv;
            buddy_neigh_sel <= buddy_neigh_sel_drv; 
            base_neigh_rel <= |base_switch_en;
            buddy_neigh_rel <= |buddy_switch_en;
        end
    end
    
endmodule
