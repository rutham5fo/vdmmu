`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:05:03 PM
// Design Name: 
// Module Name: benes_stage_B_top
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

/*
module benes_stage_B_top #(
        parameter TEST_EN           = 0,
        parameter INPUTS            = 32,
        parameter NODES             = INPUTS/2,
        parameter ADDR_W            = $clog2(INPUTS),
        parameter STAGES            = $clog2(INPUTS)
    )(
        input wire                          clk,
        input wire                          reset_n,
        input wire  [ADDR_W*INPUTS-1:0]     addr_in,
        input wire  [INPUTS-1:0]            valid_in,
        input wire  [NODES*STAGES-1:0]      stage_A_scb_in,
        
        // Test wires
        //output wire [ADDR_W*INPUTS-1:0]     addr_out,
        //--------------------------------------------------
        output wire [INPUTS-1:0]            valid_out,
        output wire [NODES*STAGES-1:0]      stage_A_scb_out,
        output wire [NODES*STAGES-1:0]      stage_B_scb_out
    );
    
    wire    [ADDR_W*INPUTS-1:0]         stage_addr_out[0:STAGES-1];
    wire    [INPUTS-1:0]                stage_valid_out[0:STAGES-1];
    wire    [NODES-1:0]                 stage_scb_out[0:STAGES-1];
    
    reg     [NODES*STAGES-1:0]          stage_A_scb;
    reg     [INPUTS-1:0]                valid_out_drv;
    
    // Test wires
    //reg     [ADDR_W*INPUTS-1:0]         addr_out_drv;
    
    //assign addr_out = addr_out_drv;
    
    //always @(posedge clk) begin
    //    addr_out_drv <= (reset_n) ? stage_addr_out[STAGES-1] : 0;
    //end
    //-------------------------------------------------
    
    assign valid_out = valid_out_drv;
    assign stage_A_scb_out = stage_A_scb;
    
    genvar i;
    
    generate
        for (i = 0; i < STAGES; i = i+1) begin
            assign stage_B_scb_out[i*NODES +: NODES] = stage_scb_out[i];
        end
    endgenerate
    
    generate
        for (i = 0; i < STAGES; i = i+1) begin
            if (i == 0) begin
                benes_stage_B #(
                    .TEST_EN(TEST_EN),
                    .INPUTS(INPUTS),
                    .NODES(NODES),
                    .ADDR_W(ADDR_W),
                    .STAGE_NUM(i),
                    .STAGES(STAGES)
                ) benes_stage_B_i (
                    .clk(clk),
                    .reset_n(reset_n),
                    .addr_in(addr_in),
                    .valid_in(valid_in),
                    
                    .addr_out(stage_addr_out[i]),
                    .valid_out(stage_valid_out[i]),
                    .scb_out(stage_scb_out[i])
                );
            end
            else begin
                benes_stage_B #(
                    .TEST_EN(TEST_EN),
                    .INPUTS(INPUTS),
                    .NODES(NODES),
                    .ADDR_W(ADDR_W),
                    .STAGE_NUM(i),
                    .STAGES(STAGES)
                ) benes_stage_B_i (
                    .clk(clk),
                    .reset_n(reset_n),
                    .addr_in(stage_addr_out[i-1]),
                    .valid_in(stage_valid_out[i-1]),
                    
                    .addr_out(stage_addr_out[i]),
                    .valid_out(stage_valid_out[i]),
                    .scb_out(stage_scb_out[i])
                );
            end
        end
    endgenerate
    
    always @(posedge clk) begin
        stage_A_scb <= (reset_n) ? stage_A_scb_in : 0;
        valid_out_drv <= (reset_n) ? stage_valid_out[STAGES-1] : 0;
    end
    
endmodule
*/
module benes_stage_B_top #(
        parameter TEST_EN           = 0,
        parameter INPUTS            = 32,
        parameter NODES             = INPUTS/2,
        parameter NODES_A           = NODES/2,
        parameter ADDR_W            = $clog2(INPUTS),
        parameter STAGES            = $clog2(NODES)+1,
        parameter STAGES_A          = STAGES-3
    )(
        input wire                          clk,
        input wire                          reset_n,
        //input wire  [ADDR_W*NODES-1:0]      addr_in,
        //input wire  [NODES-1:0]             valid_in,
        input wire  [ADDR_W*INPUTS-1:0]     addr_in,
        input wire  [INPUTS-1:0]            valid_in,
        input wire  [NODES_A*STAGES_A-1:0]  stage_A_scb_in,
        input wire                          stage_A_done,
        
        // --------- Test Output ----------------
        //output wire [ADDR_W*INPUTS-1:0]     addr_out,
        // --------------------------------------
        output wire [INPUTS-1:0]            valid_out,
        output wire [NODES_A*STAGES_A-1:0]  stage_A_scb_out,
        output wire [NODES*STAGES-1:0]      stage_B_scb_out
    );
    
    //wire    [ADDR_W-1:0]                in_addr_unpkd[0:INPUTS-1];
    //wire    [ADDR_W*INPUTS-1:0]         in_addr;
    //wire    [INPUTS-1:0]                in_addr_valid;
    wire    [ADDR_W*INPUTS-1:0]         stage_addr_out[0:STAGES-1];
    wire    [INPUTS-1:0]                stage_valid_out[0:STAGES-1];
    wire    [NODES-1:0]                 stage_scb_out[0:STAGES-1];
    
    reg     [NODES_A*STAGES_A-1:0]      stage_A_scb;
    reg     [INPUTS-1:0]                valid_out_drv;
    
    // Test wires
    //reg     [ADDR_W*INPUTS-1:0]         addr_out_drv;
    //--------------------------------------------------
    
    // Test wires
    //assign addr_out = addr_out_drv;
    //-----------------------------------
    assign valid_out = valid_out_drv;
    assign stage_A_scb_out = stage_A_scb;
    
    genvar i;
    /*
    generate
        for (i = 0; i < NODES; i = i+1) begin
            assign in_addr_unpkd[2*i] = addr_in[i*ADDR_W +: ADDR_W];
            assign in_addr_unpkd[2*i+1] = 0;
            assign in_addr_valid[2*i] = valid_in[i];
            assign in_addr_valid[2*i+1] = 1'b0;
        end
    endgenerate
    
    generate
        for (i = 0; i < INPUTS; i = i+1) begin
            assign in_addr[i*ADDR_W +: ADDR_W] = in_addr_unpkd[i];
        end
    endgenerate
    */
    generate
        for (i = 0; i < STAGES; i = i+1) begin
            assign stage_B_scb_out[i*NODES +: NODES] = stage_scb_out[i];
        end
    endgenerate
    
    generate
        for (i = 0; i < STAGES; i = i+1) begin
            if (i == 0) begin
                benes_stage_B #(
                    .TEST_EN(TEST_EN),
                    .INPUTS(INPUTS),
                    .NODES(NODES),
                    .ADDR_W(ADDR_W),
                    .STAGE_NUM(i),
                    .STAGES(STAGES)
                ) benes_stage_B_i (
                    .clk(clk),
                    .reset_n(reset_n),
                    .scb_en(stage_A_done),
                    //.addr_in(in_addr),
                    //.valid_in(in_addr_valid),
                    .addr_in(addr_in),
                    .valid_in(valid_in),
                    
                    .addr_out(stage_addr_out[i]),
                    .valid_out(stage_valid_out[i]),
                    .scb_out(stage_scb_out[i])
                );
            end
            else begin
                benes_stage_B #(
                    .INPUTS(INPUTS),
                    .NODES(NODES),
                    .ADDR_W(ADDR_W),
                    .STAGE_NUM(i),
                    .STAGES(STAGES)
                ) benes_stage_B_i (
                    .clk(clk),
                    .reset_n(reset_n),
                    .scb_en(stage_A_done),
                    .addr_in(stage_addr_out[i-1]),
                    .valid_in(stage_valid_out[i-1]),
                    
                    .addr_out(stage_addr_out[i]),
                    .valid_out(stage_valid_out[i]),
                    .scb_out(stage_scb_out[i])
                );
            end
        end
    endgenerate
    
    always @(posedge clk) begin
        if (!reset_n) begin
            stage_A_scb <= 0;
            valid_out_drv <= 0;
        end
        else begin
            stage_A_scb <= (stage_A_done) ? stage_A_scb_in : stage_A_scb;
            valid_out_drv <= (stage_A_done) ? stage_valid_out[STAGES-1] : valid_out_drv;
        end
        // Test wire
        //addr_out_drv <= (reset_n) ? stage_addr_out[STAGES-1] : 0;
        //-----------------------------------------------------------
    end
    
endmodule
