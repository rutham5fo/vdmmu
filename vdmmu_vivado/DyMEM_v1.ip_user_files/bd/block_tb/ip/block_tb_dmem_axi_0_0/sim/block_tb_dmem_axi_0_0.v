// (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// (c) Copyright 2022-2024 Advanced Micro Devices, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:hls:dmem_axi:1.0
// IP Revision: 2113651386

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "HLS" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module block_tb_dmem_axi_0_0 (
  o_reset_n_ap_vld,
  o_req_valid_ap_vld,
  o_req_type_ap_vld,
  o_req_bytes_ap_vld,
  o_req_trans_id_ap_vld,
  s_axi_DMEM_ctrl_AWADDR,
  s_axi_DMEM_ctrl_AWVALID,
  s_axi_DMEM_ctrl_AWREADY,
  s_axi_DMEM_ctrl_WDATA,
  s_axi_DMEM_ctrl_WSTRB,
  s_axi_DMEM_ctrl_WVALID,
  s_axi_DMEM_ctrl_WREADY,
  s_axi_DMEM_ctrl_BRESP,
  s_axi_DMEM_ctrl_BVALID,
  s_axi_DMEM_ctrl_BREADY,
  s_axi_DMEM_ctrl_ARADDR,
  s_axi_DMEM_ctrl_ARVALID,
  s_axi_DMEM_ctrl_ARREADY,
  s_axi_DMEM_ctrl_RDATA,
  s_axi_DMEM_ctrl_RRESP,
  s_axi_DMEM_ctrl_RVALID,
  s_axi_DMEM_ctrl_RREADY,
  i_heap_full,
  i_rep_ack,
  i_rep_trans_id,
  o_reset_n,
  o_req_valid,
  o_req_type,
  o_req_bytes,
  o_req_trans_id,
  ap_clk,
  ap_rst_n
);

output wire o_reset_n_ap_vld;
output wire o_req_valid_ap_vld;
output wire o_req_type_ap_vld;
output wire o_req_bytes_ap_vld;
output wire o_req_trans_id_ap_vld;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_DMEM_ctrl AWADDR" *)
input wire [6 : 0] s_axi_DMEM_ctrl_AWADDR;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_DMEM_ctrl AWVALID" *)
input wire s_axi_DMEM_ctrl_AWVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_DMEM_ctrl AWREADY" *)
output wire s_axi_DMEM_ctrl_AWREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_DMEM_ctrl WDATA" *)
input wire [31 : 0] s_axi_DMEM_ctrl_WDATA;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_DMEM_ctrl WSTRB" *)
input wire [3 : 0] s_axi_DMEM_ctrl_WSTRB;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_DMEM_ctrl WVALID" *)
input wire s_axi_DMEM_ctrl_WVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_DMEM_ctrl WREADY" *)
output wire s_axi_DMEM_ctrl_WREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_DMEM_ctrl BRESP" *)
output wire [1 : 0] s_axi_DMEM_ctrl_BRESP;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_DMEM_ctrl BVALID" *)
output wire s_axi_DMEM_ctrl_BVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_DMEM_ctrl BREADY" *)
input wire s_axi_DMEM_ctrl_BREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_DMEM_ctrl ARADDR" *)
input wire [6 : 0] s_axi_DMEM_ctrl_ARADDR;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_DMEM_ctrl ARVALID" *)
input wire s_axi_DMEM_ctrl_ARVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_DMEM_ctrl ARREADY" *)
output wire s_axi_DMEM_ctrl_ARREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_DMEM_ctrl RDATA" *)
output wire [31 : 0] s_axi_DMEM_ctrl_RDATA;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_DMEM_ctrl RRESP" *)
output wire [1 : 0] s_axi_DMEM_ctrl_RRESP;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_DMEM_ctrl RVALID" *)
output wire s_axi_DMEM_ctrl_RVALID;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_DMEM_ctrl, ADDR_WIDTH 7, DATA_WIDTH 32, PROTOCOL AXI4LITE, READ_WRITE_MODE READ_WRITE, FREQ_HZ 100000000, ID_WIDTH 0, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN block_tb_processing_system7_0_0_FCLK_CLK0, NUM_READ\
_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_DMEM_ctrl RREADY" *)
input wire s_axi_DMEM_ctrl_RREADY;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME i_heap_full, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 i_heap_full DATA" *)
input wire [0 : 0] i_heap_full;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME i_rep_ack, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 i_rep_ack DATA" *)
input wire [0 : 0] i_rep_ack;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME i_rep_trans_id, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 i_rep_trans_id DATA" *)
input wire [7 : 0] i_rep_trans_id;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME o_reset_n, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 o_reset_n DATA" *)
output wire [0 : 0] o_reset_n;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME o_req_valid, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 o_req_valid DATA" *)
output wire [0 : 0] o_req_valid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME o_req_type, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 o_req_type DATA" *)
output wire [0 : 0] o_req_type;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME o_req_bytes, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 o_req_bytes DATA" *)
output wire [31 : 0] o_req_bytes;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME o_req_trans_id, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 o_req_trans_id DATA" *)
output wire [7 : 0] o_req_trans_id;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ap_clk, ASSOCIATED_BUSIF s_axi_DMEM_ctrl, ASSOCIATED_RESET ap_rst_n, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN block_tb_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ap_clk CLK" *)
input wire ap_clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ap_rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 ap_rst_n RST" *)
input wire ap_rst_n;

(* SDX_KERNEL = "true" *)
(* SDX_KERNEL_TYPE = "hls" *)
(* SDX_KERNEL_SIM_INST = "" *)
  dmem_axi #(
    .C_S_AXI_DMEM_CTRL_ADDR_WIDTH(7),
    .C_S_AXI_DMEM_CTRL_DATA_WIDTH(32)
  ) inst (
    .o_reset_n_ap_vld(o_reset_n_ap_vld),
    .o_req_valid_ap_vld(o_req_valid_ap_vld),
    .o_req_type_ap_vld(o_req_type_ap_vld),
    .o_req_bytes_ap_vld(o_req_bytes_ap_vld),
    .o_req_trans_id_ap_vld(o_req_trans_id_ap_vld),
    .s_axi_DMEM_ctrl_AWADDR(s_axi_DMEM_ctrl_AWADDR),
    .s_axi_DMEM_ctrl_AWVALID(s_axi_DMEM_ctrl_AWVALID),
    .s_axi_DMEM_ctrl_AWREADY(s_axi_DMEM_ctrl_AWREADY),
    .s_axi_DMEM_ctrl_WDATA(s_axi_DMEM_ctrl_WDATA),
    .s_axi_DMEM_ctrl_WSTRB(s_axi_DMEM_ctrl_WSTRB),
    .s_axi_DMEM_ctrl_WVALID(s_axi_DMEM_ctrl_WVALID),
    .s_axi_DMEM_ctrl_WREADY(s_axi_DMEM_ctrl_WREADY),
    .s_axi_DMEM_ctrl_BRESP(s_axi_DMEM_ctrl_BRESP),
    .s_axi_DMEM_ctrl_BVALID(s_axi_DMEM_ctrl_BVALID),
    .s_axi_DMEM_ctrl_BREADY(s_axi_DMEM_ctrl_BREADY),
    .s_axi_DMEM_ctrl_ARADDR(s_axi_DMEM_ctrl_ARADDR),
    .s_axi_DMEM_ctrl_ARVALID(s_axi_DMEM_ctrl_ARVALID),
    .s_axi_DMEM_ctrl_ARREADY(s_axi_DMEM_ctrl_ARREADY),
    .s_axi_DMEM_ctrl_RDATA(s_axi_DMEM_ctrl_RDATA),
    .s_axi_DMEM_ctrl_RRESP(s_axi_DMEM_ctrl_RRESP),
    .s_axi_DMEM_ctrl_RVALID(s_axi_DMEM_ctrl_RVALID),
    .s_axi_DMEM_ctrl_RREADY(s_axi_DMEM_ctrl_RREADY),
    .i_heap_full(i_heap_full),
    .i_rep_ack(i_rep_ack),
    .i_rep_trans_id(i_rep_trans_id),
    .o_reset_n(o_reset_n),
    .o_req_valid(o_req_valid),
    .o_req_type(o_req_type),
    .o_req_bytes(o_req_bytes),
    .o_req_trans_id(o_req_trans_id),
    .ap_clk(ap_clk),
    .ap_rst_n(ap_rst_n)
  );
endmodule
