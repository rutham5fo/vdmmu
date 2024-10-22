`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:22:26 PM
// Design Name: 
// Module Name: mapper
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


module mapper #(
        parameter TEST_EN       = 0,
        parameter BUFFER_WR     = 0,
        parameter BUFFER_RD     = 1,
        parameter BUFFER_TRANS  = 1,
        parameter MEM_PORTS     = 32,
        parameter BENES_PORTS   = MEM_PORTS/2,
        parameter AP_WINDOW     = 2,
        parameter TRANSLATORS   = BENES_PORTS/AP_WINDOW,
        parameter TRANS_W       = $clog2(TRANSLATORS),
        parameter DATA_W        = 8,
        parameter OFFSET        = 11,
        parameter MEM_W         = $clog2(MEM_PORTS),
        parameter ADDR_W        = OFFSET+MEM_W+1,            // +1 for rd,wr en
        parameter MEM_CTRL      = OFFSET+1
    )(
        input wire                              clk,
        input wire                              reset_n,
        //input wire                              ap_rebase,
        input wire                              benes_restart,
        //input wire                              manual,
        //input wire  [MEM_W-1:0]                 window_base,
        // From OS (PS)
        input wire                              ps_addr_valid,
        input wire  [TRANS_W-1:0]               ps_trans_id,
        input wire  [ADDR_W-1:0]                ps_addr_bus,
        input wire  [DATA_W-1:0]                ps_wr_data_bus,
        // From Master (RTL)
        input wire  [TRANSLATORS-1:0]           pl_addr_valid,
        input wire  [ADDR_W*TRANSLATORS-1:0]    pl_addr_bus,
        input wire  [DATA_W*TRANSLATORS-1:0]    pl_wr_data_bus,
        // From memory
        input wire  [DATA_W*MEM_PORTS-1:0]      mem_pl_rd_data,
        input wire  [DATA_W*MEM_PORTS-1:0]      mem_ps_rd_data,
        // From allocator
        input wire  [MEM_W*MEM_PORTS-1:0]       vtp_map,
        input wire  [MEM_W*TRANSLATORS-1:0]     trans_max_addr,
        input wire  [TRANSLATORS-1:0]           trans_active,
        input wire  [MEM_W*TRANSLATORS-1:0]     trans_base_addr,
        
        // To OS (PS)
        output wire                             ps_rd_data_valid,
        output wire [DATA_W-1:0]                ps_rd_data_bus,
        // To Master (RTL)
        output wire [TRANSLATORS-1:0]           pl_rd_data_valid,
        output wire [TRANSLATORS-1:0]           trans_port_ready,
        output wire [DATA_W*TRANSLATORS-1:0]    pl_rd_data_bus,
        // To memory
        output wire [MEM_PORTS-1:0]             mem_port_en,
        output wire [MEM_CTRL*MEM_PORTS-1:0]    mem_ps_addr,
        output wire [MEM_CTRL*MEM_PORTS-1:0]    mem_pl_addr,
        output wire [DATA_W*MEM_PORTS-1:0]      mem_ps_wr_data,
        output wire [DATA_W*MEM_PORTS-1:0]      mem_pl_wr_data
    );
    
    localparam B_NODES_A                = BENES_PORTS/2;
    localparam B_NODES_B                = MEM_PORTS/2;
    localparam B_STAGES_A               = $clog2(B_NODES_A)-1;
    localparam B_STAGES_B               = $clog2(B_NODES_B)+1;
    localparam DATA_D                   = DATA_W+MEM_CTRL;
    localparam DATA_U                   = DATA_W;
    
    // Translator
    wire    [MEM_W*BENES_PORTS-1:0]     i_pmap_addr;
    wire    [BENES_PORTS-1:0]           i_pmap_valid;
    wire    [MEM_W*BENES_PORTS-1:0]     r_pmap_addr;
    wire    [BENES_PORTS-1:0]           r_pmap_valid;
    wire    [MEM_CTRL*BENES_PORTS-1:0]  i_mem_op_ctrl;
    wire    [DATA_W*BENES_PORTS-1:0]    i_mem_wr_data;
    wire    [DATA_W*BENES_PORTS-1:0]    i_mem_rd_data;
    wire    [DATA_U*TRANSLATORS-1:0]    pl_r_data_bus;
    wire    [TRANSLATORS-1:0]           pl_r_data_valid;
    wire    [DATA_U-1:0]                pl_rd_data_bus_unpkd[0:TRANSLATORS-1];
    wire    [TRANSLATORS-1:0]           i_port_ready;
    
    // PS related
    wire                                ps_r_data_valid;
    wire    [DATA_W-1:0]                ps_r_data;
    wire    [DATA_W*MEM_PORTS-1:0]      ps_wr_data;
    wire    [MEM_CTRL*MEM_PORTS-1:0]    ps_ctrl;
    
    // Benes
    wire    [MEM_PORTS-1:0]             benes_valid_out;
    
    // Switch
    wire    [DATA_U*BENES_PORTS-1:0]    sw_up_rd_data;
    wire    [DATA_D*BENES_PORTS-1:0]    sw_down_in;
    wire    [DATA_D*MEM_PORTS-1:0]      sw_down_out;
    wire    [MEM_CTRL-1:0]              sw_out_op_ctrl[0:MEM_PORTS-1];
    wire    [DATA_W-1:0]                sw_out_wr_data[0:MEM_PORTS-1];
    
    // Misc
    wire    [B_NODES_A*B_STAGES_A-1:0]  sw_stage_A_scb;
    wire    [B_NODES_B*B_STAGES_B-1:0]  sw_stage_B_scb;
    wire                                batch_start;
        
    genvar i;
    integer k;
    
    assign trans_port_ready = i_port_ready;
    assign mem_port_en = benes_valid_out;
        
    generate
        for (i = 0; i < BENES_PORTS; i = i+1) begin
            // Switch
            assign sw_down_in[i*DATA_D +: DATA_D] = {i_mem_wr_data[i*DATA_W +: DATA_W], i_mem_op_ctrl[i*MEM_CTRL +: MEM_CTRL]};
            // Translator
            assign i_mem_rd_data[i*DATA_U +: DATA_U] = sw_up_rd_data[i*DATA_U +: DATA_U];
        end
    endgenerate
    
    generate
        for (i = 0; i < MEM_PORTS; i = i+1) begin
            assign sw_out_op_ctrl[i] = sw_down_out[i*DATA_D +: MEM_CTRL];
            assign sw_out_wr_data[i] = sw_down_out[i*DATA_D+MEM_CTRL +: DATA_W];
        end
    endgenerate
    
    //(* dont_touch = "yes" *)
    translator #(
        .BUFFER_TRANS(BUFFER_TRANS),
        .MEM_PORTS(MEM_PORTS),
        .BENES_PORTS(BENES_PORTS),
        .WINDOW_W(AP_WINDOW),
        .NODES(TRANSLATORS),
        .NODE_W(TRANS_W),
        .DATA_W(DATA_W),
        .OFFSET(OFFSET),
        .MEM_W(MEM_W),
        .ADDR_W(ADDR_W),
        .MEM_CTRL(MEM_CTRL)
    ) translator_i (
        .clk(clk),
        .reset_n(reset_n),
        //.ap_rebase(ap_rebase),
        .benes_restart(benes_restart),
        .benes_batch_start(batch_start),
        //.manual(manual),
        //.window_base(window_base),
        .pl_addr_valid(pl_addr_valid),
        .pl_addr(pl_addr_bus),
        .pl_wr_data(pl_wr_data_bus),
        .mem_rd_data(i_mem_rd_data),
        .vtp_map(vtp_map),
        .trans_base_addr(trans_base_addr),
        .trans_max_addr(trans_max_addr),
        .trans_active(trans_active),
        // PS
        .ps_addr_valid(ps_addr_valid),
        .ps_trans_id(ps_trans_id),
        .ps_addr_bus(ps_addr_bus),
        .ps_wr_data_bus(ps_wr_data_bus),
        .mem_ps_rd_data(mem_ps_rd_data),
        
        // PS
        .ps_rd_data_bus(ps_r_data),
        .mem_ps_wr_data(ps_wr_data),
        .mem_ps_addr(ps_ctrl),
        // Others
        .pl_rd_data(pl_r_data_bus),
        .phy_map_addr(i_pmap_addr),
        .phy_map_valid(i_pmap_valid),
        .mem_op_ctrl(i_mem_op_ctrl),
        .mem_wr_data(i_mem_wr_data),
        .trans_port_ready(i_port_ready)
    );
    
    //(* dont_touch = "yes" *)
    benes #(
        .TEST_EN(TEST_EN),
        .MEM_PORTS(MEM_PORTS),
        .TRANSLATORS(BENES_PORTS),
        .NODES_A(B_NODES_A),
        .NODES_B(B_NODES_B),
        .ADDR_W(MEM_W),
        .STAGES_A(B_STAGES_A),
        .STAGES_B(B_STAGES_B)
    ) benes_i (
        .clk(clk),
        .reset_n(reset_n),
        .addr_in(r_pmap_addr),
        .addr_valid_in(r_pmap_valid),
        .stage_restart(benes_restart),
        
        .port_valid_out(benes_valid_out),
        .stage_A_scb_out(sw_stage_A_scb),
        .stage_B_scb_out(sw_stage_B_scb),
        .batch_start(batch_start)
    );
    
    //(* dont_touch = "yes" *)
    switch_top #(
        .MEM_PORTS(MEM_PORTS),
        .TRANSLATORS(BENES_PORTS),
        .DATA_D(DATA_D),
        .DATA_U(DATA_U),
        .NODES_A(B_NODES_A),
        .NODES_B(B_NODES_B),
        .STAGES_A(B_STAGES_A),
        .STAGES_B(B_STAGES_B)
    ) switch_i (
        .scb_A_in(sw_stage_A_scb),
        .scb_B_in(sw_stage_B_scb),
        .data_down_in(sw_down_in),
        .data_up_in(mem_pl_rd_data),
        
        .data_down_out(sw_down_out),
        .data_up_out(sw_up_rd_data)
    );
    
    generate
        if (!BUFFER_TRANS) begin        : BUFFER_TRANSLATOR_TO_BENES
            assign r_pmap_addr = i_pmap_addr;
            assign r_pmap_valid = i_pmap_valid;
        end
        else begin
            reg     [MEM_W-1:0]             r_pmap_addr_regs[0:BENES_PORTS-1];
            reg     [BENES_PORTS-1:0]       r_pmap_valid_regs;
            
            assign r_pmap_valid = r_pmap_valid_regs;
            
            for (i = 0; i < BENES_PORTS; i = i+1) begin
                assign r_pmap_addr[i*MEM_W +: MEM_W] = r_pmap_addr_regs[i];
            end
            
            always @(posedge clk) begin
                if (!reset_n) begin
                    for (k = 0; k < BENES_PORTS; k = k+1) begin
                        r_pmap_addr_regs[k] <= 0;
                        r_pmap_valid_regs[k] <= 0;
                    end
                end
                else begin
                    for (k = 0; k < BENES_PORTS; k = k+1) begin
                        r_pmap_addr_regs[k] <= i_pmap_addr[k*MEM_W +: MEM_W];
                        r_pmap_valid_regs[k] <= i_pmap_valid[k];
                    end
                end
            end
        end
    endgenerate
    
    generate
        if (!BUFFER_RD) begin       : BUFFER_READS_PS
            assign ps_rd_data_bus = ps_r_data;
            assign ps_rd_data_valid = ps_r_data_valid;
        end
        else begin
            reg     [DATA_U-1:0]                ps_r_data_regs;
            reg                                 ps_r_data_valid_regs;
            
            assign ps_rd_data_bus = ps_r_data_regs;
            assign ps_rd_data_valid = ps_r_data_valid_regs;
            
            always @(posedge clk) begin
                ps_r_data_valid_regs <= (reset_n) ? ps_r_data_valid : 1'b0;
            end
            
            always @(posedge clk) begin
                ps_r_data_regs <= (reset_n) ? ps_r_data : 0;
            end
        end
    endgenerate
    
    generate
        if (!BUFFER_WR) begin       : BUFFER_WRITES_PS
            reg                                 ps_r_data_valid_regs;
            
            assign mem_ps_wr_data = ps_wr_data;
            assign mem_ps_addr = ps_ctrl;
            assign ps_r_data_valid = ps_r_data_valid_regs;
            
            always @(posedge clk) begin
                ps_r_data_valid_regs <= (reset_n && ps_addr_valid && !ps_addr_bus[ADDR_W-1]) ? 1'b1 : 1'b0;
            end
        end
        else begin
            reg     [1:0]                       ps_r_data_valid_regs;
            reg     [DATA_W-1:0]                ps_wr_data_regs[0:MEM_PORTS-1];
            reg     [MEM_CTRL-1:0]              ps_ctrl_regs[0:MEM_PORTS-1];
            
            wire                                ps_r_data_vld_check;
            
            assign ps_r_data_vld_check = (reset_n && ps_addr_valid && !ps_addr_bus[ADDR_W-1]) ? 1'b1 : 1'b0;
            assign ps_r_data_valid = ps_r_data_valid_regs[1];
            
            for (i = 0; i < MEM_PORTS; i = i+1) begin
                assign mem_ps_wr_data[i*DATA_W +: DATA_W] = ps_wr_data_regs[i];
                assign mem_ps_addr[i*MEM_CTRL +: MEM_CTRL] = ps_ctrl_regs[i];
            end
            
            always @(posedge clk) begin
                ps_r_data_valid_regs <= {ps_r_data_valid_regs[0], ps_r_data_vld_check};
            end
            
            always @(posedge clk) begin
                if (!reset_n) begin
                    for (k = 0; k < MEM_PORTS; k = k+1) begin
                        ps_wr_data_regs[k] <= 0;
                        ps_ctrl_regs[k] <= 0;
                    end
                end
                else begin
                    for (k = 0; k < MEM_PORTS; k = k+1) begin
                        ps_wr_data_regs[k] <= ps_wr_data[k*DATA_W +: DATA_W];
                        ps_ctrl_regs[k] <= ps_ctrl[k*MEM_CTRL +: MEM_CTRL];
                    end
                end
            end
        end
    endgenerate
    
    generate
        if (!BUFFER_RD) begin                   : BUFFER_READS_PL
            assign pl_rd_data_bus = pl_r_data_bus;
            assign pl_rd_data_valid = pl_r_data_valid;
        end
        else begin
            reg     [DATA_U-1:0]                pl_rd_data_bus_regs[0:TRANSLATORS-1];
            reg     [TRANSLATORS-1:0]           pl_r_data_valid_regs;
            
            assign pl_rd_data_valid = pl_r_data_valid_regs;
            
            for (i = 0; i < TRANSLATORS; i = i+1) begin
                assign pl_rd_data_bus_unpkd[i] = pl_r_data_bus[i*DATA_U +: DATA_U];
                assign pl_rd_data_bus[i*DATA_U +: DATA_U] = pl_rd_data_bus_regs[i];
            end
            
            always @(posedge clk) begin
                pl_r_data_valid_regs <= (reset_n) ? pl_r_data_valid : 0;
            end
            
            always @(posedge clk) begin
                if (!reset_n) begin
                    for (k = 0; k < TRANSLATORS; k = k+1) begin
                        pl_rd_data_bus_regs[k] <= 0;
                    end
                end
                else begin
                    for (k = 0; k < TRANSLATORS; k = k+1) begin
                        pl_rd_data_bus_regs[k] <= pl_rd_data_bus_unpkd[k];
                    end
                end
            end
            
        end
    endgenerate
    
    generate
        if (!BUFFER_WR) begin               : BUFFER_WRITES_PL
            reg     [TRANSLATORS-1:0]       pl_w_data_valid_regs;
            
            assign pl_r_data_valid = pl_w_data_valid_regs;
            
            for (i = 0; i < MEM_PORTS; i = i+1) begin
                assign mem_pl_addr[i*MEM_CTRL +: MEM_CTRL] = sw_out_op_ctrl[i];
                assign mem_pl_wr_data[i*DATA_W +: DATA_W] = sw_out_wr_data[i];
            end
                        
            always @(posedge clk) begin
                for (k = 0; k < TRANSLATORS; k = k+1) begin
                    pl_w_data_valid_regs[k] <= (reset_n && pl_addr_valid[k] && !pl_addr_bus[(k*ADDR_W)+ADDR_W-1] && i_port_ready[k]) ? 1'b1 : 1'b0;
                end
            end
        end
        else begin
            reg     [MEM_CTRL-1:0]              mem_pl_addr_regs[0:MEM_PORTS-1];
            reg     [DATA_W-1:0]                mem_pl_wr_data_regs[0:MEM_PORTS-1];
            reg     [TRANSLATORS-1:0]           pl_w_data_valid_regs[0:1];
            
            assign pl_r_data_valid = pl_w_data_valid_regs[1];
            
            for (i = 0; i < MEM_PORTS; i = i+1) begin
                assign mem_pl_addr[i*MEM_CTRL +: MEM_CTRL] = mem_pl_addr_regs[i];
                assign mem_pl_wr_data[i*DATA_W +: DATA_W] = mem_pl_wr_data_regs[i];
            end
            
            always @(posedge clk) begin
                for (k = 0; k < TRANSLATORS; k = k+1) begin
                    pl_w_data_valid_regs[0][k] <= (reset_n && pl_addr_valid[k] && !pl_addr_bus[(k*ADDR_W)+ADDR_W-1] && i_port_ready[k]) ? 1'b1 : 1'b0;
                    pl_w_data_valid_regs[1] <= (reset_n) ? pl_w_data_valid_regs[0] : 0;
                end
            end
            
            always @(posedge clk) begin
                if (!reset_n) begin
                    for (k = 0; k < MEM_PORTS; k = k+1) begin
                        mem_pl_addr_regs[k] <= 0;
                        mem_pl_wr_data_regs[k] <= 0;
                    end
                end
                else begin
                    for (k = 0; k < MEM_PORTS; k = k+1) begin
                        mem_pl_addr_regs[k] <= sw_out_op_ctrl[k];
                        mem_pl_wr_data_regs[k] <= sw_out_wr_data[k];
                    end
                end
            end
            
        end
    endgenerate
    
endmodule
