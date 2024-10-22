`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 01:28:08 PM
// Design Name: 
// Module Name: node_init
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


module node_init #(
        parameter INPUTS                = 16,
        parameter BASE_NUM              = 0,
        parameter BUDDY_NUM             = 4,
        parameter STAGE_NUM             = 0,
        parameter ADDR_W                = $clog2(INPUTS),
        parameter ASSOC_W               = $clog2(INPUTS/2),
        parameter STAGE_ADDR_W          = ADDR_W-1,
        parameter STAGES                = $clog2(INPUTS/2)
    )(
        input wire  [ADDR_W-1:0]                base_addr_0_in,
        input wire  [ADDR_W-1:0]                base_addr_1_in,
        input wire  [ADDR_W-1:0]                buddy_addr_0_in,
        input wire  [ADDR_W-1:0]                buddy_addr_1_in,
        input wire                              base_valid_0_in,
        input wire                              base_valid_1_in,
        input wire                              buddy_valid_0_in,
        input wire                              buddy_valid_1_in,
        input wire                              cur_base_scb,
        input wire                              cur_buddy_scb,
        
        output wire [ADDR_W-1:0]                base_addr_0_out,
        output wire [ADDR_W-1:0]                base_addr_1_out,
        output wire [ADDR_W-1:0]                buddy_addr_0_out,
        output wire [ADDR_W-1:0]                buddy_addr_1_out,
        output wire                             base_valid_0_out,
        output wire                             base_valid_1_out,
        output wire                             buddy_valid_0_out,
        output wire                             buddy_valid_1_out,
        output wire [ASSOC_W-1:0]               init_base_assoc,
        output wire [ASSOC_W-1:0]               init_buddy_assoc,
        output wire                             init_base_scb,
        output wire                             init_buddy_scb
    );
    
    localparam SCB_BIT              = STAGES-STAGE_NUM;
    
    // Node
    wire                                buddy_node_rel;
    wire                                nodes_tied;
    
    // Base
    wire                                base_scb_drv;
    wire                                base_0_tied;
    wire                                base_1_tied;
    
    // Buddy
    wire                                buddy_scb_drv;
    
    // Stage address
    wire    [STAGE_ADDR_W-1:0]          base_Saddr_0;
    wire    [STAGE_ADDR_W-1:0]          base_Saddr_1;
    wire    [STAGE_ADDR_W-1:0]          buddy_Saddr_0;
    wire    [STAGE_ADDR_W-1:0]          buddy_Saddr_1;
    
    assign base_Saddr_0 = base_addr_0_in[0 +: STAGE_ADDR_W];
    assign base_Saddr_1 = base_addr_1_in[0 +: STAGE_ADDR_W];
    assign buddy_Saddr_0 = buddy_addr_0_in[0 +: STAGE_ADDR_W];
    assign buddy_Saddr_1 = buddy_addr_1_in[0 +: STAGE_ADDR_W];
    
    // Relate node and buddy scb_drvs
    // [Note]: All drvs are with respect to input_0
    assign base_scb_drv = (base_valid_0_in) ? base_addr_0_in[SCB_BIT] : ~base_addr_1_in[SCB_BIT];
    assign buddy_scb_drv = (buddy_valid_0_in) ? buddy_addr_0_in[SCB_BIT] : ~buddy_addr_1_in[SCB_BIT];
    // Establish node ties
    //assign base_0_tied = (base_valid_0_in && ((base_addr_0_in[SCB_BIT-1] == buddy_addr_0_in[SCB_BIT-1] && buddy_valid_0_in) || (base_addr_0_in[SCB_BIT-1] == buddy_addr_1_in[SCB_BIT-1] && buddy_valid_1_in))) ? 1'b1 : 1'b0;
    assign base_0_tied = (base_valid_0_in && ((base_Saddr_0 == buddy_Saddr_0 && buddy_valid_0_in) || (base_Saddr_0 == buddy_Saddr_1 && buddy_valid_1_in))) ? 1'b1 : 1'b0;
    //assign base_1_tied = (base_valid_1_in && ((base_addr_1_in[SCB_BIT-1] == buddy_addr_0_in[SCB_BIT-1] && buddy_valid_0_in) || (base_addr_1_in[SCB_BIT-1] == buddy_addr_1_in[SCB_BIT-1] && buddy_valid_1_in))) ? 1'b1 : 1'b0;
    assign base_1_tied = (base_valid_1_in && ((base_Saddr_1 == buddy_Saddr_0 && buddy_valid_0_in) || (base_Saddr_1 == buddy_Saddr_1 && buddy_valid_1_in))) ? 1'b1 : 1'b0;
    assign nodes_tied = base_0_tied | base_1_tied;
    // Establish buddy_node_relation
    //assign buddy_node_rel = ((base_valid_0_in && (buddy_addr_0_in[SCB_BIT -: 2] == base_addr_0_in[SCB_BIT -: 2] && buddy_valid_0_in)) || (base_valid_1_in && (buddy_addr_1_in[SCB_BIT -: 2] == base_addr_1_in[SCB_BIT -: 2] && buddy_valid_1_in))) ? 1'b1 : 1'b0;         // 1 is opposite (not equal) and 0 is equal
    assign buddy_node_rel = ((base_valid_0_in && (buddy_Saddr_0 == base_Saddr_0 && buddy_valid_0_in)) || (base_valid_1_in && (buddy_Saddr_1 == base_Saddr_1 && buddy_valid_1_in))) ? 1'b1 : 1'b0;         // 1 is opposite (not equal) and 0 is equal
    // Compute sub node SCBs
    assign init_base_scb = base_scb_drv;
    assign init_buddy_scb = (nodes_tied) ? buddy_node_rel^base_scb_drv : buddy_scb_drv;
    // Comput sub node assoc
    assign init_base_assoc = BASE_NUM;
    assign init_buddy_assoc = (nodes_tied) ? BASE_NUM : BUDDY_NUM;
    
    // Set mux outputs
    assign base_addr_0_out = (cur_base_scb) ? base_addr_1_in : base_addr_0_in;
    assign base_addr_1_out = (cur_base_scb) ? base_addr_0_in : base_addr_1_in;
    assign buddy_addr_0_out = (cur_buddy_scb) ? buddy_addr_1_in : buddy_addr_0_in;
    assign buddy_addr_1_out = (cur_buddy_scb) ? buddy_addr_0_in : buddy_addr_1_in;
    assign base_valid_0_out = (cur_base_scb) ? base_valid_1_in : base_valid_0_in;
    assign base_valid_1_out = (cur_base_scb) ? base_valid_0_in : base_valid_1_in;
    assign buddy_valid_0_out = (cur_buddy_scb) ? buddy_valid_1_in : buddy_valid_0_in;
    assign buddy_valid_1_out = (cur_buddy_scb) ? buddy_valid_0_in : buddy_valid_1_in;
    
    //always @(*) begin
    //    if (STAGES-STAGE_NUM == 1) begin
    //        $display("%t: init_base_scb = %0d, init_buddy_scb = %0d | base_addr_0 = %0d, base_addr_1 = %0d | buddy_addr_0 = %0d, buddy_addr_1 = %0d | base_addr_0_in[SCB_BIT -: 2] = %0b, buddy_addr_0_in[SCB_BIT -: 2] = %0b | base_addr_1_in[SCB_BIT -: 2] = %0b, buddy_addr_1_in[SCB_BIT -: 2] = %0b", $time, init_base_scb, init_buddy_scb, base_addr_0_in, base_addr_1_in, buddy_addr_0_in, buddy_addr_1_in, base_addr_0_in[SCB_BIT -: 2], buddy_addr_0_in[SCB_BIT -: 2], base_addr_1_in[SCB_BIT -: 2], buddy_addr_1_in[SCB_BIT -: 2]);
    //    end
    //end
    
endmodule
