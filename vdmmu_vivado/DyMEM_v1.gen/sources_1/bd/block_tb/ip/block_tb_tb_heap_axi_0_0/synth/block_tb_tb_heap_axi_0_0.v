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


// IP VLNV: xilinx.com:hls:tb_heap_axi:1.0
// IP Revision: 2113670989

(* X_CORE_INFO = "tb_heap_axi,Vivado 2023.2" *)
(* CHECK_LICENSE_TYPE = "block_tb_tb_heap_axi_0_0,tb_heap_axi,{}" *)
(* CORE_GENERATION_INFO = "block_tb_tb_heap_axi_0_0,tb_heap_axi,{x_ipProduct=Vivado 2023.2,x_ipVendor=xilinx.com,x_ipLibrary=hls,x_ipName=tb_heap_axi,x_ipVersion=1.0,x_ipCoreRevision=2113670989,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,C_S_AXI_PS_WR_ADDR_WIDTH=6,C_S_AXI_PS_WR_DATA_WIDTH=32}" *)
(* IP_DEFINITION_SOURCE = "HLS" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module block_tb_tb_heap_axi_0_0 (
  o_ps_addr_valid_ap_vld,
  o_ps_trans_id_ap_vld,
  o_ps_addr_ap_vld,
  o_ps_wr_data_ap_vld,
  o_ps_we_ap_vld,
  s_axi_PS_wr_AWADDR,
  s_axi_PS_wr_AWVALID,
  s_axi_PS_wr_AWREADY,
  s_axi_PS_wr_WDATA,
  s_axi_PS_wr_WSTRB,
  s_axi_PS_wr_WVALID,
  s_axi_PS_wr_WREADY,
  s_axi_PS_wr_BRESP,
  s_axi_PS_wr_BVALID,
  s_axi_PS_wr_BREADY,
  s_axi_PS_wr_ARADDR,
  s_axi_PS_wr_ARVALID,
  s_axi_PS_wr_ARREADY,
  s_axi_PS_wr_RDATA,
  s_axi_PS_wr_RRESP,
  s_axi_PS_wr_RVALID,
  s_axi_PS_wr_RREADY,
  ap_clk,
  ap_rst_n,
  interrupt,
  o_ps_addr_valid,
  o_ps_trans_id,
  o_ps_addr,
  o_ps_wr_data,
  o_ps_we
);

output wire o_ps_addr_valid_ap_vld;
output wire o_ps_trans_id_ap_vld;
output wire o_ps_addr_ap_vld;
output wire o_ps_wr_data_ap_vld;
output wire o_ps_we_ap_vld;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_PS_wr AWADDR" *)
input wire [5 : 0] s_axi_PS_wr_AWADDR;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_PS_wr AWVALID" *)
input wire s_axi_PS_wr_AWVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_PS_wr AWREADY" *)
output wire s_axi_PS_wr_AWREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_PS_wr WDATA" *)
input wire [31 : 0] s_axi_PS_wr_WDATA;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_PS_wr WSTRB" *)
input wire [3 : 0] s_axi_PS_wr_WSTRB;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_PS_wr WVALID" *)
input wire s_axi_PS_wr_WVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_PS_wr WREADY" *)
output wire s_axi_PS_wr_WREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_PS_wr BRESP" *)
output wire [1 : 0] s_axi_PS_wr_BRESP;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_PS_wr BVALID" *)
output wire s_axi_PS_wr_BVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_PS_wr BREADY" *)
input wire s_axi_PS_wr_BREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_PS_wr ARADDR" *)
input wire [5 : 0] s_axi_PS_wr_ARADDR;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_PS_wr ARVALID" *)
input wire s_axi_PS_wr_ARVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_PS_wr ARREADY" *)
output wire s_axi_PS_wr_ARREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_PS_wr RDATA" *)
output wire [31 : 0] s_axi_PS_wr_RDATA;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_PS_wr RRESP" *)
output wire [1 : 0] s_axi_PS_wr_RRESP;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_PS_wr RVALID" *)
output wire s_axi_PS_wr_RVALID;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_PS_wr, ADDR_WIDTH 6, DATA_WIDTH 32, PROTOCOL AXI4LITE, READ_WRITE_MODE READ_WRITE, FREQ_HZ 100000000, ID_WIDTH 0, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN block_tb_processing_system7_0_0_FCLK_CLK0, NUM_READ_THR\
EADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_PS_wr RREADY" *)
input wire s_axi_PS_wr_RREADY;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ap_clk, ASSOCIATED_BUSIF s_axi_PS_wr, ASSOCIATED_RESET ap_rst_n, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN block_tb_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ap_clk CLK" *)
input wire ap_clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ap_rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 ap_rst_n RST" *)
input wire ap_rst_n;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME interrupt, SENSITIVITY LEVEL_HIGH, PortWidth 1" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 interrupt INTERRUPT" *)
output wire interrupt;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME o_ps_addr_valid, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 o_ps_addr_valid DATA" *)
output wire [0 : 0] o_ps_addr_valid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME o_ps_trans_id, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 o_ps_trans_id DATA" *)
output wire [7 : 0] o_ps_trans_id;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME o_ps_addr, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 o_ps_addr DATA" *)
output wire [31 : 0] o_ps_addr;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME o_ps_wr_data, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 o_ps_wr_data DATA" *)
output wire [7 : 0] o_ps_wr_data;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME o_ps_we, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 o_ps_we DATA" *)
output wire [0 : 0] o_ps_we;

(* SDX_KERNEL = "true" *)
(* SDX_KERNEL_TYPE = "hls" *)
(* SDX_KERNEL_SYNTH_INST = "inst" *)
  tb_heap_axi #(
    .C_S_AXI_PS_WR_ADDR_WIDTH(6),
    .C_S_AXI_PS_WR_DATA_WIDTH(32)
  ) inst (
    .o_ps_addr_valid_ap_vld(o_ps_addr_valid_ap_vld),
    .o_ps_trans_id_ap_vld(o_ps_trans_id_ap_vld),
    .o_ps_addr_ap_vld(o_ps_addr_ap_vld),
    .o_ps_wr_data_ap_vld(o_ps_wr_data_ap_vld),
    .o_ps_we_ap_vld(o_ps_we_ap_vld),
    .s_axi_PS_wr_AWADDR(s_axi_PS_wr_AWADDR),
    .s_axi_PS_wr_AWVALID(s_axi_PS_wr_AWVALID),
    .s_axi_PS_wr_AWREADY(s_axi_PS_wr_AWREADY),
    .s_axi_PS_wr_WDATA(s_axi_PS_wr_WDATA),
    .s_axi_PS_wr_WSTRB(s_axi_PS_wr_WSTRB),
    .s_axi_PS_wr_WVALID(s_axi_PS_wr_WVALID),
    .s_axi_PS_wr_WREADY(s_axi_PS_wr_WREADY),
    .s_axi_PS_wr_BRESP(s_axi_PS_wr_BRESP),
    .s_axi_PS_wr_BVALID(s_axi_PS_wr_BVALID),
    .s_axi_PS_wr_BREADY(s_axi_PS_wr_BREADY),
    .s_axi_PS_wr_ARADDR(s_axi_PS_wr_ARADDR),
    .s_axi_PS_wr_ARVALID(s_axi_PS_wr_ARVALID),
    .s_axi_PS_wr_ARREADY(s_axi_PS_wr_ARREADY),
    .s_axi_PS_wr_RDATA(s_axi_PS_wr_RDATA),
    .s_axi_PS_wr_RRESP(s_axi_PS_wr_RRESP),
    .s_axi_PS_wr_RVALID(s_axi_PS_wr_RVALID),
    .s_axi_PS_wr_RREADY(s_axi_PS_wr_RREADY),
    .ap_clk(ap_clk),
    .ap_rst_n(ap_rst_n),
    .interrupt(interrupt),
    .o_ps_addr_valid(o_ps_addr_valid),
    .o_ps_trans_id(o_ps_trans_id),
    .o_ps_addr(o_ps_addr),
    .o_ps_wr_data(o_ps_wr_data),
    .o_ps_we(o_ps_we)
  );
endmodule
