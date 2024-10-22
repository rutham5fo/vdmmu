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


// IP VLNV: xilinx.com:module_ref:dmem_manager:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module block_tb_dmem_manager_0_0 (
  clk,
  reset_n,
  benes_restart,
  req_valid,
  req_type,
  req_bytes,
  req_trans,
  ps_addr_valid,
  ps_trans_id,
  ps_addr_bus,
  ps_wr_data_bus,
  ps_we,
  pl_addr_valid,
  pl_addr_bus,
  pl_wr_data_bus,
  rep_trans,
  rep_ack,
  heap_full,
  ps_rd_data_bus,
  ps_rd_data_valid,
  pl_port_ready,
  pl_rd_data_bus,
  pl_rd_data_valid
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN block_tb_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME reset_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset_n RST" *)
input wire reset_n;
input wire benes_restart;
input wire req_valid;
input wire req_type;
input wire [14 : 0] req_bytes;
input wire [1 : 0] req_trans;
input wire ps_addr_valid;
input wire [1 : 0] ps_trans_id;
input wire [14 : 0] ps_addr_bus;
input wire [7 : 0] ps_wr_data_bus;
input wire ps_we;
input wire [3 : 0] pl_addr_valid;
input wire [63 : 0] pl_addr_bus;
input wire [31 : 0] pl_wr_data_bus;
output wire [1 : 0] rep_trans;
output wire rep_ack;
output wire heap_full;
output wire [7 : 0] ps_rd_data_bus;
output wire ps_rd_data_valid;
output wire [3 : 0] pl_port_ready;
output wire [31 : 0] pl_rd_data_bus;
output wire [3 : 0] pl_rd_data_valid;

  dmem_manager #(
    .TEST_EN(0),
    .BUFFER_WR(0),
    .BUFFER_RD(1),
    .BUFFER_TRANS(1),
    .MEM_PORTS(16),
    .BENES_PORTS(8),
    .AP_WINDOW(2),
    .TRANSLATORS(4),
    .DATA_W(8),
    .OFFSET(11),
    .MEM_W(4),
    .ADDR_W(16),
    .MEM_CTRL(12),
    .TRANS_W(2),
    .UNIT_BYTES(2048),
    .REQ_W(15),
    .BRAM_SIZE("18Kb")
  ) inst (
    .clk(clk),
    .reset_n(reset_n),
    .benes_restart(benes_restart),
    .req_valid(req_valid),
    .req_type(req_type),
    .req_bytes(req_bytes),
    .req_trans(req_trans),
    .ps_addr_valid(ps_addr_valid),
    .ps_trans_id(ps_trans_id),
    .ps_addr_bus(ps_addr_bus),
    .ps_wr_data_bus(ps_wr_data_bus),
    .ps_we(ps_we),
    .pl_addr_valid(pl_addr_valid),
    .pl_addr_bus(pl_addr_bus),
    .pl_wr_data_bus(pl_wr_data_bus),
    .rep_trans(rep_trans),
    .rep_ack(rep_ack),
    .heap_full(heap_full),
    .ps_rd_data_bus(ps_rd_data_bus),
    .ps_rd_data_valid(ps_rd_data_valid),
    .pl_port_ready(pl_port_ready),
    .pl_rd_data_bus(pl_rd_data_bus),
    .pl_rd_data_valid(pl_rd_data_valid)
  );
endmodule
