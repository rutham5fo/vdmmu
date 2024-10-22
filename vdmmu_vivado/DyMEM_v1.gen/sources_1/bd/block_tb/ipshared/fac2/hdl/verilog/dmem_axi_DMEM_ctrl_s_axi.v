// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
`timescale 1ns/1ps
module dmem_axi_DMEM_ctrl_s_axi
#(parameter
    C_S_AXI_ADDR_WIDTH = 7,
    C_S_AXI_DATA_WIDTH = 32
)(
    input  wire                          ACLK,
    input  wire                          ARESET,
    input  wire                          ACLK_EN,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] AWADDR,
    input  wire                          AWVALID,
    output wire                          AWREADY,
    input  wire [C_S_AXI_DATA_WIDTH-1:0] WDATA,
    input  wire [C_S_AXI_DATA_WIDTH/8-1:0] WSTRB,
    input  wire                          WVALID,
    output wire                          WREADY,
    output wire [1:0]                    BRESP,
    output wire                          BVALID,
    input  wire                          BREADY,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] ARADDR,
    input  wire                          ARVALID,
    output wire                          ARREADY,
    output wire [C_S_AXI_DATA_WIDTH-1:0] RDATA,
    output wire [1:0]                    RRESP,
    output wire                          RVALID,
    input  wire                          RREADY,
    output wire [7:0]                    i_reset,
    output wire [7:0]                    i_req_valid,
    output wire [7:0]                    i_req_type,
    output wire [31:0]                   i_req_bytes,
    output wire [7:0]                    i_req_trans_id,
    input  wire [7:0]                    o_rep_trans_id,
    input  wire                          o_rep_trans_id_ap_vld,
    input  wire [7:0]                    o_rep_ack,
    input  wire                          o_rep_ack_ap_vld,
    input  wire [7:0]                    o_heap_full,
    input  wire                          o_heap_full_ap_vld
);
//------------------------Address Info-------------------
// Protocol Used: ap_ctrl_none
//
// 0x00 : reserved
// 0x04 : reserved
// 0x08 : reserved
// 0x0c : reserved
// 0x10 : Data signal of i_reset
//        bit 7~0 - i_reset[7:0] (Read/Write)
//        others  - reserved
// 0x14 : reserved
// 0x18 : Data signal of i_req_valid
//        bit 7~0 - i_req_valid[7:0] (Read/Write)
//        others  - reserved
// 0x1c : reserved
// 0x20 : Data signal of i_req_type
//        bit 7~0 - i_req_type[7:0] (Read/Write)
//        others  - reserved
// 0x24 : reserved
// 0x28 : Data signal of i_req_bytes
//        bit 31~0 - i_req_bytes[31:0] (Read/Write)
// 0x2c : reserved
// 0x30 : Data signal of i_req_trans_id
//        bit 7~0 - i_req_trans_id[7:0] (Read/Write)
//        others  - reserved
// 0x34 : reserved
// 0x38 : Data signal of o_rep_trans_id
//        bit 7~0 - o_rep_trans_id[7:0] (Read)
//        others  - reserved
// 0x3c : Control signal of o_rep_trans_id
//        bit 0  - o_rep_trans_id_ap_vld (Read/COR)
//        others - reserved
// 0x48 : Data signal of o_rep_ack
//        bit 7~0 - o_rep_ack[7:0] (Read)
//        others  - reserved
// 0x4c : Control signal of o_rep_ack
//        bit 0  - o_rep_ack_ap_vld (Read/COR)
//        others - reserved
// 0x58 : Data signal of o_heap_full
//        bit 7~0 - o_heap_full[7:0] (Read)
//        others  - reserved
// 0x5c : Control signal of o_heap_full
//        bit 0  - o_heap_full_ap_vld (Read/COR)
//        others - reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

//------------------------Parameter----------------------
localparam
    ADDR_I_RESET_DATA_0        = 7'h10,
    ADDR_I_RESET_CTRL          = 7'h14,
    ADDR_I_REQ_VALID_DATA_0    = 7'h18,
    ADDR_I_REQ_VALID_CTRL      = 7'h1c,
    ADDR_I_REQ_TYPE_DATA_0     = 7'h20,
    ADDR_I_REQ_TYPE_CTRL       = 7'h24,
    ADDR_I_REQ_BYTES_DATA_0    = 7'h28,
    ADDR_I_REQ_BYTES_CTRL      = 7'h2c,
    ADDR_I_REQ_TRANS_ID_DATA_0 = 7'h30,
    ADDR_I_REQ_TRANS_ID_CTRL   = 7'h34,
    ADDR_O_REP_TRANS_ID_DATA_0 = 7'h38,
    ADDR_O_REP_TRANS_ID_CTRL   = 7'h3c,
    ADDR_O_REP_ACK_DATA_0      = 7'h48,
    ADDR_O_REP_ACK_CTRL        = 7'h4c,
    ADDR_O_HEAP_FULL_DATA_0    = 7'h58,
    ADDR_O_HEAP_FULL_CTRL      = 7'h5c,
    WRIDLE                     = 2'd0,
    WRDATA                     = 2'd1,
    WRRESP                     = 2'd2,
    WRRESET                    = 2'd3,
    RDIDLE                     = 2'd0,
    RDDATA                     = 2'd1,
    RDRESET                    = 2'd2,
    ADDR_BITS                = 7;

//------------------------Local signal-------------------
    reg  [1:0]                    wstate = WRRESET;
    reg  [1:0]                    wnext;
    reg  [ADDR_BITS-1:0]          waddr;
    wire [C_S_AXI_DATA_WIDTH-1:0] wmask;
    wire                          aw_hs;
    wire                          w_hs;
    reg  [1:0]                    rstate = RDRESET;
    reg  [1:0]                    rnext;
    reg  [C_S_AXI_DATA_WIDTH-1:0] rdata;
    wire                          ar_hs;
    wire [ADDR_BITS-1:0]          raddr;
    // internal registers
    reg  [7:0]                    int_i_reset = 'b0;
    reg  [7:0]                    int_i_req_valid = 'b0;
    reg  [7:0]                    int_i_req_type = 'b0;
    reg  [31:0]                   int_i_req_bytes = 'b0;
    reg  [7:0]                    int_i_req_trans_id = 'b0;
    reg                           int_o_rep_trans_id_ap_vld;
    reg  [7:0]                    int_o_rep_trans_id = 'b0;
    reg                           int_o_rep_ack_ap_vld;
    reg  [7:0]                    int_o_rep_ack = 'b0;
    reg                           int_o_heap_full_ap_vld;
    reg  [7:0]                    int_o_heap_full = 'b0;

//------------------------Instantiation------------------


//------------------------AXI write fsm------------------
assign AWREADY = (wstate == WRIDLE);
assign WREADY  = (wstate == WRDATA);
assign BRESP   = 2'b00;  // OKAY
assign BVALID  = (wstate == WRRESP);
assign wmask   = { {8{WSTRB[3]}}, {8{WSTRB[2]}}, {8{WSTRB[1]}}, {8{WSTRB[0]}} };
assign aw_hs   = AWVALID & AWREADY;
assign w_hs    = WVALID & WREADY;

// wstate
always @(posedge ACLK) begin
    if (ARESET)
        wstate <= WRRESET;
    else if (ACLK_EN)
        wstate <= wnext;
end

// wnext
always @(*) begin
    case (wstate)
        WRIDLE:
            if (AWVALID)
                wnext = WRDATA;
            else
                wnext = WRIDLE;
        WRDATA:
            if (WVALID)
                wnext = WRRESP;
            else
                wnext = WRDATA;
        WRRESP:
            if (BREADY)
                wnext = WRIDLE;
            else
                wnext = WRRESP;
        default:
            wnext = WRIDLE;
    endcase
end

// waddr
always @(posedge ACLK) begin
    if (ACLK_EN) begin
        if (aw_hs)
            waddr <= AWADDR[ADDR_BITS-1:0];
    end
end

//------------------------AXI read fsm-------------------
assign ARREADY = (rstate == RDIDLE);
assign RDATA   = rdata;
assign RRESP   = 2'b00;  // OKAY
assign RVALID  = (rstate == RDDATA);
assign ar_hs   = ARVALID & ARREADY;
assign raddr   = ARADDR[ADDR_BITS-1:0];

// rstate
always @(posedge ACLK) begin
    if (ARESET)
        rstate <= RDRESET;
    else if (ACLK_EN)
        rstate <= rnext;
end

// rnext
always @(*) begin
    case (rstate)
        RDIDLE:
            if (ARVALID)
                rnext = RDDATA;
            else
                rnext = RDIDLE;
        RDDATA:
            if (RREADY & RVALID)
                rnext = RDIDLE;
            else
                rnext = RDDATA;
        default:
            rnext = RDIDLE;
    endcase
end

// rdata
always @(posedge ACLK) begin
    if (ACLK_EN) begin
        if (ar_hs) begin
            rdata <= 'b0;
            case (raddr)
                ADDR_I_RESET_DATA_0: begin
                    rdata <= int_i_reset[7:0];
                end
                ADDR_I_REQ_VALID_DATA_0: begin
                    rdata <= int_i_req_valid[7:0];
                end
                ADDR_I_REQ_TYPE_DATA_0: begin
                    rdata <= int_i_req_type[7:0];
                end
                ADDR_I_REQ_BYTES_DATA_0: begin
                    rdata <= int_i_req_bytes[31:0];
                end
                ADDR_I_REQ_TRANS_ID_DATA_0: begin
                    rdata <= int_i_req_trans_id[7:0];
                end
                ADDR_O_REP_TRANS_ID_DATA_0: begin
                    rdata <= int_o_rep_trans_id[7:0];
                end
                ADDR_O_REP_TRANS_ID_CTRL: begin
                    rdata[0] <= int_o_rep_trans_id_ap_vld;
                end
                ADDR_O_REP_ACK_DATA_0: begin
                    rdata <= int_o_rep_ack[7:0];
                end
                ADDR_O_REP_ACK_CTRL: begin
                    rdata[0] <= int_o_rep_ack_ap_vld;
                end
                ADDR_O_HEAP_FULL_DATA_0: begin
                    rdata <= int_o_heap_full[7:0];
                end
                ADDR_O_HEAP_FULL_CTRL: begin
                    rdata[0] <= int_o_heap_full_ap_vld;
                end
            endcase
        end
    end
end


//------------------------Register logic-----------------
assign i_reset        = int_i_reset;
assign i_req_valid    = int_i_req_valid;
assign i_req_type     = int_i_req_type;
assign i_req_bytes    = int_i_req_bytes;
assign i_req_trans_id = int_i_req_trans_id;
// int_i_reset[7:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_i_reset[7:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_I_RESET_DATA_0)
            int_i_reset[7:0] <= (WDATA[31:0] & wmask) | (int_i_reset[7:0] & ~wmask);
    end
end

// int_i_req_valid[7:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_i_req_valid[7:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_I_REQ_VALID_DATA_0)
            int_i_req_valid[7:0] <= (WDATA[31:0] & wmask) | (int_i_req_valid[7:0] & ~wmask);
    end
end

// int_i_req_type[7:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_i_req_type[7:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_I_REQ_TYPE_DATA_0)
            int_i_req_type[7:0] <= (WDATA[31:0] & wmask) | (int_i_req_type[7:0] & ~wmask);
    end
end

// int_i_req_bytes[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_i_req_bytes[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_I_REQ_BYTES_DATA_0)
            int_i_req_bytes[31:0] <= (WDATA[31:0] & wmask) | (int_i_req_bytes[31:0] & ~wmask);
    end
end

// int_i_req_trans_id[7:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_i_req_trans_id[7:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_I_REQ_TRANS_ID_DATA_0)
            int_i_req_trans_id[7:0] <= (WDATA[31:0] & wmask) | (int_i_req_trans_id[7:0] & ~wmask);
    end
end

// int_o_rep_trans_id
always @(posedge ACLK) begin
    if (ARESET)
        int_o_rep_trans_id <= 0;
    else if (ACLK_EN) begin
        if (o_rep_trans_id_ap_vld)
            int_o_rep_trans_id <= o_rep_trans_id;
    end
end

// int_o_rep_trans_id_ap_vld
always @(posedge ACLK) begin
    if (ARESET)
        int_o_rep_trans_id_ap_vld <= 1'b0;
    else if (ACLK_EN) begin
        if (o_rep_trans_id_ap_vld)
            int_o_rep_trans_id_ap_vld <= 1'b1;
        else if (ar_hs && raddr == ADDR_O_REP_TRANS_ID_CTRL)
            int_o_rep_trans_id_ap_vld <= 1'b0; // clear on read
    end
end

// int_o_rep_ack
always @(posedge ACLK) begin
    if (ARESET)
        int_o_rep_ack <= 0;
    else if (ACLK_EN) begin
        if (o_rep_ack_ap_vld)
            int_o_rep_ack <= o_rep_ack;
    end
end

// int_o_rep_ack_ap_vld
always @(posedge ACLK) begin
    if (ARESET)
        int_o_rep_ack_ap_vld <= 1'b0;
    else if (ACLK_EN) begin
        if (o_rep_ack_ap_vld)
            int_o_rep_ack_ap_vld <= 1'b1;
        else if (ar_hs && raddr == ADDR_O_REP_ACK_CTRL)
            int_o_rep_ack_ap_vld <= 1'b0; // clear on read
    end
end

// int_o_heap_full
always @(posedge ACLK) begin
    if (ARESET)
        int_o_heap_full <= 0;
    else if (ACLK_EN) begin
        if (o_heap_full_ap_vld)
            int_o_heap_full <= o_heap_full;
    end
end

// int_o_heap_full_ap_vld
always @(posedge ACLK) begin
    if (ARESET)
        int_o_heap_full_ap_vld <= 1'b0;
    else if (ACLK_EN) begin
        if (o_heap_full_ap_vld)
            int_o_heap_full_ap_vld <= 1'b1;
        else if (ar_hs && raddr == ADDR_O_HEAP_FULL_CTRL)
            int_o_heap_full_ap_vld <= 1'b0; // clear on read
    end
end


//------------------------Memory logic-------------------

endmodule
