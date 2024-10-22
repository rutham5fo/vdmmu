`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/09/2024 06:13:22 PM
// Design Name: 
// Module Name: access_port
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


module access_port #(
        parameter BUFFER_TRANS  = 1,
        parameter MEM_PORTS     = 32,
        parameter DATA_W        = 32,
        parameter OFFSET        = 9,
        parameter MEM_W         = $clog2(MEM_PORTS),
        parameter ADDR_W        = OFFSET+MEM_W+1,            // +1 for rd,wr en
        parameter MEM_CTRL      = OFFSET+1,
        parameter BENES_PORTS   = MEM_PORTS/2,
        parameter WINDOW_W      = 2,
        parameter AP_NUM        = 0
    )(
        input wire                          clk,
        input wire                          reset_n,
        // Control
        input wire                          ap_rebase,
        input wire                          benes_restart,
        input wire                          benes_batch_start,
        input wire                          re_loc,             // Assert to relocate AP's Virtual destination to current_dest + WINDOW_SIZE
        //input wire                          manual,             // Assert to enable to manual set virtual desitination to window_base
        input wire  [MEM_W-1:0]             window_base,
        // From proc
        input wire                          addr_valid,
        input wire                          addr_we,
        input wire  [OFFSET-1:0]            addr_offset,
        input wire  [DATA_W-1:0]            wr_data_bus,
        // From memory
        input wire  [DATA_W-1:0]            mem_rd_data,
        // From Allocator (unicast)
        input wire  [MEM_W-1:0]             base_addr,
        input wire  [MEM_W-1:0]             max_addr,
        input wire                          active_in,
        // Broadcasted to all translators
        input wire  [MEM_W*MEM_PORTS-1:0]   vtp_map,
        
        // To translator_port
        output wire [MEM_W-1:0]             cur_virt_addr,
        // To proc
        output wire                         port_ready,
        output wire [DATA_W-1:0]            rd_data_bus,
        // To Benes
        output wire [MEM_W-1:0]             phy_map_addr,
        output wire                         phy_map_valid,
        // To memory
        output wire [MEM_CTRL-1:0]          mem_op_ctrl,
        output wire [DATA_W-1:0]            mem_wr_data
    );
    
    // The last stage needs 3 cycles (log(8)) since it can handle 8 inputs, hence subtract 3
    //localparam SWITCH_LOAD_A        = $clog2(BENES_PORTS)-1;
    //localparam SWITCH_STAGES_A      = SWITCH_LOAD_A-2;
    //localparam SWITCH_LOAD_TIME     = ((SWITCH_LOAD_A*(SWITCH_LOAD_A+1))/2) + 1;        // +SWITCH_STAGES_A for stage load latency, +1 for SWITCH_STAGE_B latency
    //localparam TRANS_LOAD_TIME      = (BUFFER_TRANS) ? SWITCH_LOAD_TIME + 1 : SWITCH_LOAD_TIME;
    //localparam TRANS_LOAD_W         = $clog2(TRANS_LOAD_TIME)+1;
    
    wire    [MEM_W-1:0]             get_phy_port;
    wire    [MEM_W-1:0]             vtp_map_unpkd[0:MEM_PORTS-1];
    
    wire                            wr_en;
    
    wire                            active_rise;
    wire                            active_fall;
    wire    [MEM_W-1:0]             virt_limit;
    
    //reg     [TRANS_LOAD_W-1:0]      benes_counter;
    //reg     [TRANS_LOAD_W-1:0]      trans_load_counter;
    //reg                             r_benes_batch_start;
    reg                             trans_load_done;
    reg     [MEM_W-1:0]             prev_map_addr;
    reg     [MEM_W-1:0]             cur_map_addr;
    
    reg     [MEM_W-1:0]             virt_addr;
    reg     [1:0]                   active_edge;
    
    reg                             init_done;
    
    genvar j;
    
    generate
        for (j = 0; j < MEM_PORTS; j = j+1) begin
            assign vtp_map_unpkd[j] = vtp_map[j*MEM_W +: MEM_W];
        end
    endgenerate
    
    assign wr_en = addr_we & addr_valid;
    
    //assign port_ready = (phy_map_addr == prev_map_addr && active_in && init_done && !ap_rebase) ? 1'b1 : 1'b0;
    //assign port_ready = (phy_map_addr == prev_map_addr && trans_load_counter == TRANS_LOAD_TIME && active_in && init_done && !ap_rebase) ? 1'b1 : 1'b0;
    assign port_ready = (phy_map_addr == prev_map_addr && trans_load_done && active_in && init_done && !ap_rebase) ? 1'b1 : 1'b0;
    assign get_phy_port = base_addr + virt_addr;
    assign phy_map_addr = vtp_map_unpkd[get_phy_port];
    assign phy_map_valid = active_in;
    
    assign mem_op_ctrl = {wr_en, addr_offset};
    assign mem_wr_data = wr_data_bus;
    assign rd_data_bus = mem_rd_data;
    
    assign active_rise = (active_edge == 2'b01) ? 1'b1 : 1'b0;
    assign active_fall = (active_edge == 2'b10) ? 1'b1 : 1'b0;
    assign virt_limit = (virt_addr+WINDOW_W < max_addr) ? 1'b0 : 1'b1;
    
    assign cur_virt_addr = virt_addr;
    
    always @(posedge clk) begin
        active_edge <= (reset_n) ? {active_edge[0], active_in} : 0;
        //r_benes_batch_start <= (reset_n) ? benes_batch_start : 0;
    end
    
    always @(posedge clk) begin
        if (!reset_n || active_fall || ap_rebase || (virt_limit && re_loc)) begin
            //virt_addr <= (manual) ? window_base + AP_NUM : AP_NUM;
            virt_addr <= window_base + AP_NUM;
        end
        else if (re_loc) begin
            //virt_addr <= (manual) ? window_base : virt_addr + WINDOW_W;
            virt_addr <= virt_addr + WINDOW_W;
        end
    end
    
    //always @(posedge clk) begin
    //    if (!reset_n || benes_restart || benes_counter == TRANS_LOAD_TIME) benes_counter <= 0;
    //    else benes_counter <= benes_counter+1;
    //end
    
    always @(posedge clk) begin
        //if (!reset_n || benes_restart || active_rise || (phy_map_addr != prev_map_addr && trans_load_counter == TRANS_LOAD_TIME && benes_counter == 0)) begin
        //if (!reset_n || benes_restart || active_rise || (cur_map_addr != prev_map_addr && trans_load_counter == TRANS_LOAD_TIME && benes_batch_start)) begin
        if (!reset_n || benes_restart || active_rise || (cur_map_addr != prev_map_addr && trans_load_done && benes_batch_start)) begin
            //trans_load_counter <= 0;
            trans_load_done <= 1'b0;
        end
        else begin
            //trans_load_counter <= (trans_load_counter != TRANS_LOAD_TIME) ? trans_load_counter+1 : trans_load_counter;
            trans_load_done <= (benes_batch_start) ? 1'b1 : trans_load_done;
        end
    end
    
    always @(posedge clk) begin
        if (!reset_n || active_fall) init_done <= 1'b0;
        else if (active_rise) init_done <= 1'b1;
    end
    
    always @(posedge clk) begin
        if (!reset_n) begin
            prev_map_addr <= 0;
            cur_map_addr <= 0;
        end
        else begin
            //prev_map_addr <= (trans_load_counter == TRANS_LOAD_TIME-1) ? phy_map_addr : prev_map_addr;
            prev_map_addr <= (benes_batch_start) ? cur_map_addr : prev_map_addr;
            cur_map_addr <= phy_map_addr;
        end
    end
    
endmodule
