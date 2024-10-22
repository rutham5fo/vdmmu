`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:25:37 PM
// Design Name: 
// Module Name: dmem_manager
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


module dmem_manager #(
        parameter TEST_EN       = 0,
        parameter BUFFER_WR     = 0,
        parameter BUFFER_RD     = 1,
        parameter BUFFER_TRANS  = 1,
        parameter MEM_PORTS     = 128,
        //parameter BENES_PORTS   = MEM_PORTS/2,
        parameter BENES_PORTS   = 8,
        parameter AP_WINDOW     = 2,
        parameter TRANSLATORS   = BENES_PORTS/AP_WINDOW,
        parameter DATA_W        = 32,
        parameter OFFSET        = 10,
        parameter MEM_W         = $clog2(MEM_PORTS),
        parameter ADDR_W        = OFFSET+MEM_W+1,            // +1 for rd,wr en
        parameter MEM_CTRL      = OFFSET+1,
        parameter TRANS_W       = $clog2(TRANSLATORS),
        parameter UNIT_BYTES    = (DATA_W/8)*(2**OFFSET),
        parameter REQ_W         = $clog2(UNIT_BYTES*MEM_PORTS),
        parameter BRAM_SIZE     = "36Kb"
    )(
        input wire                              clk,
        input wire                              reset_n,
        input wire                              benes_restart,
        //input wire                              ap_rebase,
        //input wire                              set_window_manual,
        //input wire  [MEM_W-1:0]                 set_window_base,
        // From OS (PS)
        input wire                              req_valid,              // 1 = valid request, 0 = invalid request
        input wire                              req_type,               // 0 = alloc, 1 = dealloc
        input wire  [REQ_W-1:0]                 req_bytes,              // Size of the request in bytes
        input wire  [TRANS_W-1:0]               req_trans,              // The translator ID for this request
        input wire                              ps_addr_valid,
        input wire  [TRANS_W-1:0]               ps_trans_id,
        input wire  [ADDR_W-2:0]                ps_addr_bus,
        input wire  [DATA_W-1:0]                ps_wr_data_bus,
        input wire                              ps_we,
        // From Master (RTL)
        input wire  [TRANSLATORS-1:0]           pl_addr_valid,
        input wire  [ADDR_W*TRANSLATORS-1:0]    pl_addr_bus,
        input wire  [DATA_W*TRANSLATORS-1:0]    pl_wr_data_bus,
        
        // To OS (PS)
        //output wire [MEM_W-1:0]                 rep_addr,              // Virtual Base address. Not used by PS, but the Translator will use this base_addr (HEAP_W) + offset (ADDR_W) [from PS], to access BRAM elems
        output wire [TRANS_W-1:0]               rep_trans,
        output wire                             rep_ack,
        output wire                             heap_full,              // Indicates the heap is full.
        output wire [DATA_W-1:0]                ps_rd_data_bus,
        output wire                             ps_rd_data_valid,
        // To Master (RTL/PS)
        output wire [TRANSLATORS-1:0]           pl_port_ready,
        output wire [DATA_W*TRANSLATORS-1:0]    pl_rd_data_bus,
        output wire [TRANSLATORS-1:0]           pl_rd_data_valid
    );
      
    // From manager
    wire    [MEM_W*MEM_PORTS-1:0]       vtp_map;
    wire    [MEM_W*TRANSLATORS-1:0]     trans_base;           // Virtual base address, used to locate the physical address (vtp_map_base + virt_offset_addr) in VTP_MAP.
    wire    [MEM_W*TRANSLATORS-1:0]     trans_alloc_size;         // Maximum allocated (accessible) size for each translator port in the mapper.
    wire    [TRANSLATORS-1:0]           trans_active;
    // From heap
    wire    [DATA_W*MEM_PORTS-1:0]      mem_pl_rd_data;
    wire    [DATA_W*MEM_PORTS-1:0]      mem_ps_rd_data;
    // To heap
    wire    [MEM_PORTS-1:0]             mem_port_en;
    wire    [MEM_CTRL*MEM_PORTS-1:0]    mem_ps_op_addr;
    wire    [MEM_CTRL*MEM_PORTS-1:0]    mem_pl_op_addr;
    wire    [DATA_W*MEM_PORTS-1:0]      mem_ps_wr_data;
    wire    [DATA_W*MEM_PORTS-1:0]      mem_pl_wr_data;
    
    // To Mapper
    wire    [ADDR_W-1:0]                i_ps_addr_bus;
    
    // To PL
    wire    [TRANSLATORS-1:0]           pl_i_port_ready;
    reg     [TRANSLATORS-1:0]           pl_r_port_ready;
    
    // Skid buffer
    wire    [ADDR_W*TRANSLATORS-1:0]    skid_pl_addr_bus;
    wire    [DATA_W*TRANSLATORS-1:0]    skid_pl_wr_data_bus;
    wire    [TRANSLATORS-1:0]           skid_pl_addr_valid;
        
    genvar i;
    
    assign i_ps_addr_bus = {ps_we, ps_addr_bus[0 +: ADDR_W-1]};
    
    assign pl_port_ready = pl_r_port_ready;
    
    generate
        if (TEST_EN >= 1) begin
            wire    [DATA_W-1:0]        mem_pl_rd_data_unpkd[0:MEM_PORTS-1];
            for (i = 0; i < MEM_PORTS; i = i+1) begin
                assign mem_pl_rd_data_unpkd[i] = mem_pl_rd_data[i*DATA_W +: DATA_W];
            end
        end
    endgenerate
    
    skids_top #(
        .TRANSLATORS(TRANSLATORS),
        .ADDR_W(ADDR_W),
        .DATA_W(DATA_W)
    ) skid_buffer_i (
        .clk(clk),
        .reset_n(reset_n),
        .pl_port_ready(pl_r_port_ready),
        .pl_addr_valid(pl_addr_valid),
        .pl_addr_bus(pl_addr_bus),
        .pl_wr_data_bus(pl_wr_data_bus),
        
        .skid_pl_addr_valid(skid_pl_addr_valid),
        .skid_pl_addr_bus(skid_pl_addr_bus),
        .skid_pl_wr_data_bus(skid_pl_wr_data_bus)
    );
    
    (* dont_touch = "yes" *)
    manager #(
        .TEST_EN(TEST_EN),
        .TRANSLATORS(TRANSLATORS),
        .HEAP_SIZE(MEM_PORTS),
        .HEAP_W(MEM_W),
        .DATA_W(DATA_W),
        .ADDR_W(OFFSET),
        .UNIT_BYTES(UNIT_BYTES),
        .REQ_W(REQ_W),
        .TRANS_W(TRANS_W)
    ) manager_i (
        .clk(clk),
        .reset_n(reset_n),
        // From PS
        .req_valid(req_valid),              // 1 = valid request, 0 = invalid request
        .req_type(req_type),               // 0 = alloc, 1 = dealloc
        .req_bytes(req_bytes),              // Size of the request in bytes
        .req_trans(req_trans),              // The translator ID for this request
        
        // To PS
        //.rep_addr(rep_addr),              // Virtual Base address. Not used by PS, but the Translator will use this base_addr (HEAP_W) + offset (ADDR_W) [from PS], to access BRAM elems
        .rep_trans(rep_trans),
        .rep_ack(rep_ack),
        .heap_full(heap_full),              // Indicates the heap is full.
        // To Mapper
        .vtp_map_out(vtp_map),
        .vtp_map_base(trans_base),           // Virtual base address, used to locate the physical address (vtp_map_base + virt_offset_addr) in VTP_MAP.
        .trans_alloc_size_out(trans_alloc_size),         // Maximum allocated (accessible) size for each translator port in the mapper.
        .trans_active_out(trans_active)
    );
    
    (* dont_touch = "yes" *)
    mapper #(
        .TEST_EN(TEST_EN),
        .BUFFER_WR(BUFFER_WR),
        .BUFFER_RD(BUFFER_RD),
        .BUFFER_TRANS(BUFFER_TRANS),
        .MEM_PORTS(MEM_PORTS),
        .BENES_PORTS(BENES_PORTS),
        .AP_WINDOW(AP_WINDOW),
        .TRANSLATORS(TRANSLATORS),
        .DATA_W(DATA_W),
        .OFFSET(OFFSET),
        .MEM_W(MEM_W),
        .ADDR_W(ADDR_W),
        .MEM_CTRL(MEM_CTRL)
    ) mapper_i (
        .clk(clk),
        .reset_n(reset_n),
        //.ap_rebase(ap_rebase),
        .benes_restart(benes_restart),
        //.manual(set_window_manual),
        //.window_base(set_window_base),
        // From OS (PS)
        .ps_addr_valid(ps_addr_valid),
        .ps_trans_id(ps_trans_id),
        .ps_addr_bus(i_ps_addr_bus),
        .ps_wr_data_bus(ps_wr_data_bus),
        // From Master (RTL)
        .pl_addr_valid(skid_pl_addr_valid),
        .pl_addr_bus(skid_pl_addr_bus),
        .pl_wr_data_bus(skid_pl_wr_data_bus),
        // From memory
        .mem_pl_rd_data(mem_pl_rd_data),
        .mem_ps_rd_data(mem_ps_rd_data),
        // From allocator
        .vtp_map(vtp_map),
        .trans_max_addr(trans_alloc_size),
        .trans_active(trans_active),
        .trans_base_addr(trans_base),
        
        // To OS (PS)
        .ps_rd_data_valid(ps_rd_data_valid),
        .ps_rd_data_bus(ps_rd_data_bus),
        // To Master (RTL/PS)
        .pl_rd_data_valid(pl_rd_data_valid),
        .trans_port_ready(pl_i_port_ready),
        .pl_rd_data_bus(pl_rd_data_bus),
        // To memory
        .mem_port_en(mem_port_en),
        .mem_ps_addr(mem_ps_op_addr),
        .mem_pl_addr(mem_pl_op_addr),
        .mem_ps_wr_data(mem_ps_wr_data),
        .mem_pl_wr_data(mem_pl_wr_data)
    );
    
    heap_memory #(
        .HEAP_SIZE(MEM_PORTS),
        .DATA_W(DATA_W),
        .OFFSET(OFFSET),
        .MEM_CTRL(MEM_CTRL),
        .BRAM_SIZE(BRAM_SIZE)
    ) heap_mem_i (
        .clk(clk),
        .reset_n(reset_n),
        .addr_a(mem_pl_op_addr),
        .addr_b(mem_ps_op_addr),
        .wr_data_a(mem_pl_wr_data),
        .wr_data_b(mem_ps_wr_data),
        .port_en(mem_port_en),
        
        .rd_data_a(mem_pl_rd_data),
        .rd_data_b(mem_ps_rd_data)
    );
    
    always @(posedge clk) begin
        pl_r_port_ready <= #1 (reset_n) ? pl_i_port_ready : 0;
    end
    
endmodule
