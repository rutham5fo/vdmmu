`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:02:15 PM
// Design Name: 
// Module Name: benes_stage_A_top
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


module benes_stage_A_top #(
        parameter TEST_EN           = 0,
        parameter INPUTS            = 32,
        parameter OUTPUTS           = INPUTS*2,
        parameter NODES             = INPUTS/2,
        parameter ADDR_W            = $clog2(INPUTS)+1,
        parameter STAGES            = $clog2(NODES)-1
    )(
        input wire                              clk,
        input wire                              reset_n,
        input wire  [ADDR_W*INPUTS-1:0]         addr_in,
        input wire  [INPUTS-1:0]                addr_valid_in,
        input wire                              stage_restart,
        
        //output wire [ADDR_W*INPUTS-1:0]         addr_out,
        //output wire [INPUTS-1:0]                addr_valid_out,
        output wire [ADDR_W*OUTPUTS-1:0]        addr_out,
        output wire [OUTPUTS-1:0]               addr_valid_out,
        output wire [NODES*STAGES-1:0]          scb_out,
        output wire                             stage_done
    );
    
    localparam STAGE_W                  = $clog2(STAGES);
    localparam IO_FACTOR                = OUTPUTS/INPUTS;
    localparam IO_DIST                  = 2*IO_FACTOR;
    localparam EVEN_ODD                 = INPUTS/2;
    
    // Manually add accumulators
    //localparam ACCUM_0                  = STAGES-1;
    //localparam ACCUM_1                  = STAGES-2;
    //localparam ACCUM_2                  = STAGES-3;
    //localparam ACCUM_3                  = STAGES-4;
    //localparam ACCUM_4                  = STAGES-5;
    
    wire    [ADDR_W-1:0]                addr_out_unpkd[0:OUTPUTS-1];
    wire    [ADDR_W*INPUTS-1:0]         i_addr_out;
    wire    [ADDR_W-1:0]                i_addr_out_unpkd[0:INPUTS-1];
    wire    [ADDR_W-1:0]                i_addr_out_even[0:EVEN_ODD-1];
    wire    [EVEN_ODD-1:0]              i_valid_out_even;
    wire    [ADDR_W-1:0]                i_addr_out_odd[0:EVEN_ODD-1];
    wire    [EVEN_ODD-1:0]              i_valid_out_odd;
    wire    [INPUTS-1:0]                i_valid_out;
    wire                                stage_start;
    wire    [ADDR_W*INPUTS-1:0]         stage_addr_out[0:STAGES-1];
    wire    [INPUTS-1:0]                stage_valid_out[0:STAGES-1];
    wire    [NODES-1:0]                 stage_scb_out[0:STAGES-1];
    wire    [STAGES-1:0]                stage_done_out;
    
    reg     [1:0]                       auto_start;
    reg                                 stage_done_reg;             // Used to auto start after completion
    
    // Manually add accumulator for stages
    //reg     [NODES-1:0]                 accum_0[0:ACCUM_0-1];
    //reg     [NODES-1:0]                 accum_1[0:ACCUM_1-1];
    //reg     [NODES-1:0]                 accum_2[0:ACCUM_2-1];
    //reg     [NODES-1:0]                 accum_3[0:ACCUM_3-1];
    //reg     [NODES-1:0]                 accum_4[0:ACCUM_4-1];
    
    genvar i, j;
    
    assign stage_start = (auto_start == 2'b01 || stage_restart || stage_done_reg) ? 1'b1 : 1'b0;
    assign i_addr_out = stage_addr_out[STAGES-1];
    assign i_valid_out = stage_valid_out[STAGES-1];
    //assign addr_out = stage_addr_out[STAGES-1];
    //assign addr_valid_out = stage_valid_out[STAGES-1];
    assign stage_done = stage_done_out[STAGES-1];
        
    // Manually add more stages
    generate
        for (i = 0; i < STAGES; i = i+1) begin
            //if (i == 0) assign scb_out[i*NODES +: NODES] = accum_0[ACCUM_0-1];
            //else if (i == 1) assign scb_out[i*NODES +: NODES] = accum_1[ACCUM_1-1];
            //else if (i == 2) assign scb_out[i*NODES +: NODES] = accum_2[ACCUM_2-1];
            //else if (i == 3) assign scb_out[i*NODES +: NODES] = accum_3[ACCUM_3-1];
            //else if (i == 4) assign scb_out[i*NODES +: NODES] = accum_4[ACCUM_4-1];
            //else assign scb_out[i*NODES +: NODES] = stage_scb_out[i];
            // Uncomment below if STAGES == 1
            assign scb_out[i*NODES +: NODES] = stage_scb_out[i];
        end
    endgenerate
    
    // Map INPUTS to OUTPUTS
    generate
        for (i = 0; i < INPUTS; i = i+1) begin
            assign i_addr_out_unpkd[i] = i_addr_out[i*ADDR_W +: ADDR_W];
        end
    endgenerate
    
    generate
        for (i = 0; i < EVEN_ODD; i = i+2) begin
            assign i_addr_out_even[i] = i_addr_out_unpkd[2*i];
            assign i_addr_out_even[i+1] = i_addr_out_unpkd[2*i+1];
            assign i_valid_out_even[i] = i_valid_out[2*i];
            assign i_valid_out_even[i+1] = i_valid_out[2*i+1];
            assign i_addr_out_odd[i] = i_addr_out_unpkd[2*i+2];
            assign i_addr_out_odd[i+1] = i_addr_out_unpkd[2*i+3];
            assign i_valid_out_odd[i] = i_valid_out[2*i+2];
            assign i_valid_out_odd[i+1] = i_valid_out[2*i+3];
        end
    endgenerate
    
    //generate
    //    for (i = 0; i < EVEN_ODD; i = i+1) begin
    //        assign addr_out_unpkd[4*i] = i_addr_out_even[i];
    //        assign addr_out_unpkd[4*i+1] = i_addr_out_odd[i];
    //        assign addr_out_unpkd[4*i+2] = 0;
    //        assign addr_out_unpkd[4*i+3] = 0;
    //        assign addr_valid_out[4*i] = i_valid_out_even[i];
    //        assign addr_valid_out[4*i+1] = i_valid_out_odd[i];
    //        assign addr_valid_out[4*i+2] = 0;
    //        assign addr_valid_out[4*i+3] = 0;
    //    end
    //endgenerate
    
    generate
        for (i = 0; i < EVEN_ODD; i = i+1) begin
            for (j = 0; j < IO_DIST; j = j+1) begin
                if (j < 2) begin
                    if (j%2 == 0) begin
                        assign addr_out_unpkd[IO_DIST*i+j] = i_addr_out_even[i];
                        assign addr_valid_out[IO_DIST*i+j] = i_valid_out_even[i];
                    end
                    else begin
                        assign addr_out_unpkd[IO_DIST*i+j] = i_addr_out_odd[i];
                        assign addr_valid_out[IO_DIST*i+j] = i_valid_out_odd[i];
                    end
                end
                else begin
                    assign addr_out_unpkd[IO_DIST*i+j] = 0;
                    assign addr_valid_out[IO_DIST*i+j] = 0;
                end
            end
        end
    endgenerate
    
    generate
        for (i = 0; i < OUTPUTS; i = i+1) begin
            assign addr_out[i*ADDR_W +: ADDR_W] = addr_out_unpkd[i];
        end
    endgenerate
    
    generate
        for (i = 0; i < STAGES; i = i+1) begin
            if (i == 0) begin
                benes_stage_A #(
                    .TEST_EN(TEST_EN),
                    .INPUTS(INPUTS),
                    .SUB_NODES(NODES),
                    .STAGE_NUM(i),
                    .ADDR_W(ADDR_W),
                    .STAGES(STAGES)
                ) benes_stage_A_i (
                    .clk(clk),
                    .reset_n(reset_n),
                    .prev_stage_done(stage_start),
                    .addr_in(addr_in),
                    .addr_valid_in(addr_valid_in),
                    
                    .stage_done(stage_done_out[i]),
                    .addr_out(stage_addr_out[i]),
                    .addr_valid_out(stage_valid_out[i]),
                    .scb_out(stage_scb_out[i])
                );
            end
            else begin
                benes_stage_A #(
                    .TEST_EN(TEST_EN),
                    .INPUTS(INPUTS),
                    .SUB_NODES(NODES),
                    .STAGE_NUM(i),
                    .ADDR_W(ADDR_W),
                    .STAGES(STAGES)
                ) benes_stage_A_i (
                    .clk(clk),
                    .reset_n(reset_n),
                    .prev_stage_done(stage_done_out[i-1]),
                    .addr_in(stage_addr_out[i-1]),
                    .addr_valid_in(stage_valid_out[i-1]),
                    
                    .stage_done(stage_done_out[i]),
                    .addr_out(stage_addr_out[i]),
                    .addr_valid_out(stage_valid_out[i]),
                    .scb_out(stage_scb_out[i])
                );
            end
        end
    endgenerate
    
    always @(posedge clk) begin
        auto_start <= {auto_start[0], reset_n};
        stage_done_reg <= stage_done;
    end
    
    // Accum 0
    /*
    generate
        for (i = 0; i < ACCUM_0; i = i+1) begin
            if (i == 0) begin
                always @(posedge clk) begin
                    accum_0[i] <= (reset_n) ? stage_scb_out[0] : 0;
                end
            end
            else begin
                always @(posedge clk) begin
                    accum_0[i] <= (reset_n) ? accum_0[i-1] : 0;
                end
            end
        end
    endgenerate
    */
    // Accum 1
    /*
    generate
        for (i = 0; i < ACCUM_1; i = i+1) begin
            if (i == 0) begin
                always @(posedge clk) begin
                    accum_1[i] <= (reset_n) ? stage_scb_out[1] : 0;
                end
            end
            else begin
                always @(posedge clk) begin
                    accum_1[i] <= (reset_n) ? accum_1[i-1] : 0;
                end
            end
        end
    endgenerate
    */
    /*
    // Accum 2
    generate
        for (i = 0; i < ACCUM_2; i = i+1) begin
            if (i == 0) begin
                always @(posedge clk) begin
                    accum_2[i] <= (reset_n) ? stage_scb_out[2] : 0;
                end
            end
            else begin
                always @(posedge clk) begin
                    accum_2[i] <= (reset_n) ? accum_2[i-1] : 0;
                end
            end
        end
    endgenerate
    */
    /*
    // Accum 3
    generate
        for (i = 0; i < ACCUM_3; i = i+1) begin
            if (i == 0) begin
                always @(posedge clk) begin
                    accum_3[i] <= (reset_n) ? stage_scb_out[3] : 0;
                end
            end
            else begin
                always @(posedge clk) begin
                    accum_3[i] <= (reset_n) ? accum_3[i-1] : 0;
                end
            end
        end
    endgenerate
    */
    /*
    // Accum 4
    generate
        for (i = 0; i < ACCUM_4; i = i+1) begin
            if (i == 0) begin
                always @(posedge clk) begin
                    accum_4[i] <= (reset_n) ? stage_scb_out[4] : 0;
                end
            end
            else begin
                always @(posedge clk) begin
                    accum_4[i] <= (reset_n) ? accum_4[i-1] : 0;
                end
            end
        end
    endgenerate
    */
endmodule
