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


// IP VLNV: xilinx.com:module_ref:dmem_stream_combine:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module block_tb_dmem_stream_combine_0_1 (
  i_pl_rd_addr_0,
  i_pl_rd_addr_1,
  i_pl_rd_addr_2,
  i_pl_rd_addr_3,
  i_pl_rd_addr_vld_0,
  i_pl_rd_addr_vld_1,
  i_pl_rd_addr_vld_2,
  i_pl_rd_addr_vld_3,
  i_mem_rd_data,
  i_mem_rd_data_vld,
  i_port_rdy,
  o_pl_rd_addr,
  o_pl_rd_addr_vld,
  o_port_rdy_0,
  o_port_rdy_1,
  o_port_rdy_2,
  o_port_rdy_3,
  o_mem_rd_data_vld_0,
  o_mem_rd_data_vld_1,
  o_mem_rd_data_vld_2,
  o_mem_rd_data_vld_3,
  o_mem_rd_data_0,
  o_mem_rd_data_1,
  o_mem_rd_data_2,
  o_mem_rd_data_3
);

input wire [31 : 0] i_pl_rd_addr_0;
input wire [31 : 0] i_pl_rd_addr_1;
input wire [31 : 0] i_pl_rd_addr_2;
input wire [31 : 0] i_pl_rd_addr_3;
input wire i_pl_rd_addr_vld_0;
input wire i_pl_rd_addr_vld_1;
input wire i_pl_rd_addr_vld_2;
input wire i_pl_rd_addr_vld_3;
input wire [31 : 0] i_mem_rd_data;
input wire [3 : 0] i_mem_rd_data_vld;
input wire [3 : 0] i_port_rdy;
output wire [63 : 0] o_pl_rd_addr;
output wire [3 : 0] o_pl_rd_addr_vld;
output wire o_port_rdy_0;
output wire o_port_rdy_1;
output wire o_port_rdy_2;
output wire o_port_rdy_3;
output wire o_mem_rd_data_vld_0;
output wire o_mem_rd_data_vld_1;
output wire o_mem_rd_data_vld_2;
output wire o_mem_rd_data_vld_3;
output wire [7 : 0] o_mem_rd_data_0;
output wire [7 : 0] o_mem_rd_data_1;
output wire [7 : 0] o_mem_rd_data_2;
output wire [7 : 0] o_mem_rd_data_3;

  dmem_stream_combine #(
    .MEM_PORTS(16),
    .BENES_PORTS(8),
    .AP_WINDOW(2),
    .TRANSLATORS(4),
    .DATA_W(8),
    .OFFSET(11),
    .MEM_W(4),
    .BUS_W(32),
    .ADDR_W(16)
  ) inst (
    .i_pl_rd_addr_0(i_pl_rd_addr_0),
    .i_pl_rd_addr_1(i_pl_rd_addr_1),
    .i_pl_rd_addr_2(i_pl_rd_addr_2),
    .i_pl_rd_addr_3(i_pl_rd_addr_3),
    .i_pl_rd_addr_vld_0(i_pl_rd_addr_vld_0),
    .i_pl_rd_addr_vld_1(i_pl_rd_addr_vld_1),
    .i_pl_rd_addr_vld_2(i_pl_rd_addr_vld_2),
    .i_pl_rd_addr_vld_3(i_pl_rd_addr_vld_3),
    .i_mem_rd_data(i_mem_rd_data),
    .i_mem_rd_data_vld(i_mem_rd_data_vld),
    .i_port_rdy(i_port_rdy),
    .o_pl_rd_addr(o_pl_rd_addr),
    .o_pl_rd_addr_vld(o_pl_rd_addr_vld),
    .o_port_rdy_0(o_port_rdy_0),
    .o_port_rdy_1(o_port_rdy_1),
    .o_port_rdy_2(o_port_rdy_2),
    .o_port_rdy_3(o_port_rdy_3),
    .o_mem_rd_data_vld_0(o_mem_rd_data_vld_0),
    .o_mem_rd_data_vld_1(o_mem_rd_data_vld_1),
    .o_mem_rd_data_vld_2(o_mem_rd_data_vld_2),
    .o_mem_rd_data_vld_3(o_mem_rd_data_vld_3),
    .o_mem_rd_data_0(o_mem_rd_data_0),
    .o_mem_rd_data_1(o_mem_rd_data_1),
    .o_mem_rd_data_2(o_mem_rd_data_2),
    .o_mem_rd_data_3(o_mem_rd_data_3)
  );
endmodule
