transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xilinx_vip
vlib riviera/xpm
vlib riviera/xil_defaultlib
vlib riviera/axi_infrastructure_v1_1_0
vlib riviera/axi_vip_v1_1_15
vlib riviera/processing_system7_vip_v1_0_17
vlib riviera/generic_baseblocks_v2_1_1
vlib riviera/axi_register_slice_v2_1_29
vlib riviera/fifo_generator_v13_2_9
vlib riviera/axi_data_fifo_v2_1_28
vlib riviera/axi_crossbar_v2_1_30
vlib riviera/lib_cdc_v1_0_2
vlib riviera/proc_sys_reset_v5_0_14
vlib riviera/axi_protocol_converter_v2_1_29

vmap xilinx_vip riviera/xilinx_vip
vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib
vmap axi_infrastructure_v1_1_0 riviera/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_15 riviera/axi_vip_v1_1_15
vmap processing_system7_vip_v1_0_17 riviera/processing_system7_vip_v1_0_17
vmap generic_baseblocks_v2_1_1 riviera/generic_baseblocks_v2_1_1
vmap axi_register_slice_v2_1_29 riviera/axi_register_slice_v2_1_29
vmap fifo_generator_v13_2_9 riviera/fifo_generator_v13_2_9
vmap axi_data_fifo_v2_1_28 riviera/axi_data_fifo_v2_1_28
vmap axi_crossbar_v2_1_30 riviera/axi_crossbar_v2_1_30
vmap lib_cdc_v1_0_2 riviera/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_14 riviera/proc_sys_reset_v5_0_14
vmap axi_protocol_converter_v2_1_29 riviera/axi_protocol_converter_v2_1_29

vlog -work xilinx_vip  -incr "+incdir+C:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l generic_baseblocks_v2_1_1 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 -l axi_protocol_converter_v2_1_29 \
"C:/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"C:/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"C:/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"C:/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"C:/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"C:/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"C:/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"C:/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"C:/Xilinx/Vivado/2023.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -incr "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ec67/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/6b2b/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_dmem_axi_0_0/drivers/dmem_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_heap_axi_0_0/drivers/tb_heap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_0_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_1_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_2_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_3_0/drivers/tb_ap_axi_v1_0/src" "+incdir+C:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l generic_baseblocks_v2_1_1 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 -l axi_protocol_converter_v2_1_29 \
"C:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  -incr \
"C:/Xilinx/Vivado/2023.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ec67/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/6b2b/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_dmem_axi_0_0/drivers/dmem_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_heap_axi_0_0/drivers/tb_heap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_0_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_1_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_2_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_3_0/drivers/tb_ap_axi_v1_0/src" "+incdir+C:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l generic_baseblocks_v2_1_1 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 -l axi_protocol_converter_v2_1_29 \
"../../../bd/block_tb/ip/block_tb_dmem_manager_0_0/sim/block_tb_dmem_manager_0_0.v" \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/fac2/hdl/verilog/dmem_axi_DMEM_ctrl_s_axi.v" \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/fac2/hdl/verilog/dmem_axi.v" \
"../../../bd/block_tb/ip/block_tb_dmem_axi_0_0/sim/block_tb_dmem_axi_0_0.v" \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/c6b2/hdl/verilog/tb_heap_axi_flow_control_loop_pipe_sequential_init.v" \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/c6b2/hdl/verilog/tb_heap_axi_ps_wr_data.v" \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/c6b2/hdl/verilog/tb_heap_axi_PS_wr_s_axi.v" \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/c6b2/hdl/verilog/tb_heap_axi.v" \
"../../../bd/block_tb/ip/block_tb_tb_heap_axi_0_0/sim/block_tb_tb_heap_axi_0_0.v" \
"../../../bd/block_tb/ip/block_tb_dmem_stream_combine_0_1/sim/block_tb_dmem_stream_combine_0_1.v" \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/e1c8/hdl/verilog/tb_ap_axi_flow_control_loop_pipe_sequential_init.v" \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/e1c8/hdl/verilog/tb_ap_axi_get_data.v" \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/e1c8/hdl/verilog/tb_ap_axi_PU_rd_s_axi.v" \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/e1c8/hdl/verilog/tb_ap_axi_put_addr.v" \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/e1c8/hdl/verilog/tb_ap_axi.v" \
"../../../bd/block_tb/ip/block_tb_tb_ap_axi_0_0/sim/block_tb_tb_ap_axi_0_0.v" \
"../../../bd/block_tb/ip/block_tb_tb_ap_axi_1_0/sim/block_tb_tb_ap_axi_1_0.v" \
"../../../bd/block_tb/ip/block_tb_tb_ap_axi_2_0/sim/block_tb_tb_ap_axi_2_0.v" \
"../../../bd/block_tb/ip/block_tb_tb_ap_axi_3_0/sim/block_tb_tb_ap_axi_3_0.v" \

vlog -work axi_infrastructure_v1_1_0  -incr -v2k5 "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ec67/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/6b2b/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_dmem_axi_0_0/drivers/dmem_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_heap_axi_0_0/drivers/tb_heap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_0_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_1_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_2_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_3_0/drivers/tb_ap_axi_v1_0/src" "+incdir+C:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l generic_baseblocks_v2_1_1 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 -l axi_protocol_converter_v2_1_29 \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_15  -incr "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ec67/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/6b2b/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_dmem_axi_0_0/drivers/dmem_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_heap_axi_0_0/drivers/tb_heap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_0_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_1_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_2_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_3_0/drivers/tb_ap_axi_v1_0/src" "+incdir+C:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l generic_baseblocks_v2_1_1 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 -l axi_protocol_converter_v2_1_29 \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/5753/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_17  -incr "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ec67/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/6b2b/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_dmem_axi_0_0/drivers/dmem_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_heap_axi_0_0/drivers/tb_heap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_0_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_1_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_2_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_3_0/drivers/tb_ap_axi_v1_0/src" "+incdir+C:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l generic_baseblocks_v2_1_1 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 -l axi_protocol_converter_v2_1_29 \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/6b2b/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ec67/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/6b2b/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_dmem_axi_0_0/drivers/dmem_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_heap_axi_0_0/drivers/tb_heap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_0_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_1_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_2_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_3_0/drivers/tb_ap_axi_v1_0/src" "+incdir+C:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l generic_baseblocks_v2_1_1 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 -l axi_protocol_converter_v2_1_29 \
"../../../bd/block_tb/ip/block_tb_processing_system7_0_0/sim/block_tb_processing_system7_0_0.v" \

vlog -work generic_baseblocks_v2_1_1  -incr -v2k5 "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ec67/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/6b2b/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_dmem_axi_0_0/drivers/dmem_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_heap_axi_0_0/drivers/tb_heap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_0_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_1_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_2_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_3_0/drivers/tb_ap_axi_v1_0/src" "+incdir+C:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l generic_baseblocks_v2_1_1 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 -l axi_protocol_converter_v2_1_29 \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/10ab/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_29  -incr -v2k5 "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ec67/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/6b2b/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_dmem_axi_0_0/drivers/dmem_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_heap_axi_0_0/drivers/tb_heap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_0_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_1_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_2_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_3_0/drivers/tb_ap_axi_v1_0/src" "+incdir+C:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l generic_baseblocks_v2_1_1 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 -l axi_protocol_converter_v2_1_29 \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ff9f/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_9  -incr -v2k5 "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ec67/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/6b2b/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_dmem_axi_0_0/drivers/dmem_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_heap_axi_0_0/drivers/tb_heap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_0_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_1_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_2_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_3_0/drivers/tb_ap_axi_v1_0/src" "+incdir+C:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l generic_baseblocks_v2_1_1 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 -l axi_protocol_converter_v2_1_29 \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ac72/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_9 -93  -incr \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ac72/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_9  -incr -v2k5 "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ec67/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/6b2b/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_dmem_axi_0_0/drivers/dmem_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_heap_axi_0_0/drivers/tb_heap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_0_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_1_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_2_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_3_0/drivers/tb_ap_axi_v1_0/src" "+incdir+C:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l generic_baseblocks_v2_1_1 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 -l axi_protocol_converter_v2_1_29 \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ac72/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_28  -incr -v2k5 "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ec67/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/6b2b/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_dmem_axi_0_0/drivers/dmem_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_heap_axi_0_0/drivers/tb_heap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_0_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_1_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_2_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_3_0/drivers/tb_ap_axi_v1_0/src" "+incdir+C:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l generic_baseblocks_v2_1_1 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 -l axi_protocol_converter_v2_1_29 \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/279e/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_30  -incr -v2k5 "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ec67/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/6b2b/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_dmem_axi_0_0/drivers/dmem_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_heap_axi_0_0/drivers/tb_heap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_0_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_1_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_2_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_3_0/drivers/tb_ap_axi_v1_0/src" "+incdir+C:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l generic_baseblocks_v2_1_1 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 -l axi_protocol_converter_v2_1_29 \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/fb47/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ec67/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/6b2b/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_dmem_axi_0_0/drivers/dmem_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_heap_axi_0_0/drivers/tb_heap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_0_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_1_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_2_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_3_0/drivers/tb_ap_axi_v1_0/src" "+incdir+C:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l generic_baseblocks_v2_1_1 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 -l axi_protocol_converter_v2_1_29 \
"../../../bd/block_tb/ip/block_tb_xbar_0/sim/block_tb_xbar_0.v" \

vcom -work lib_cdc_v1_0_2 -93  -incr \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_14 -93  -incr \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/408c/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../bd/block_tb/ip/block_tb_rst_ps7_0_100M_0/sim/block_tb_rst_ps7_0_100M_0.vhd" \

vlog -work axi_protocol_converter_v2_1_29  -incr -v2k5 "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ec67/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/6b2b/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_dmem_axi_0_0/drivers/dmem_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_heap_axi_0_0/drivers/tb_heap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_0_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_1_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_2_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_3_0/drivers/tb_ap_axi_v1_0/src" "+incdir+C:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l generic_baseblocks_v2_1_1 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 -l axi_protocol_converter_v2_1_29 \
"../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/a63f/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/ec67/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ipshared/6b2b/hdl" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_dmem_axi_0_0/drivers/dmem_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_heap_axi_0_0/drivers/tb_heap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_0_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_1_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_2_0/drivers/tb_ap_axi_v1_0/src" "+incdir+../../../../DyMEM_v1.gen/sources_1/bd/block_tb/ip/block_tb_tb_ap_axi_3_0/drivers/tb_ap_axi_v1_0/src" "+incdir+C:/Xilinx/Vivado/2023.2/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_15 -l processing_system7_vip_v1_0_17 -l generic_baseblocks_v2_1_1 -l axi_register_slice_v2_1_29 -l fifo_generator_v13_2_9 -l axi_data_fifo_v2_1_28 -l axi_crossbar_v2_1_30 -l lib_cdc_v1_0_2 -l proc_sys_reset_v5_0_14 -l axi_protocol_converter_v2_1_29 \
"../../../bd/block_tb/ip/block_tb_auto_pc_0/sim/block_tb_auto_pc_0.v" \
"../../../bd/block_tb/sim/block_tb.v" \

vlog -work xil_defaultlib \
"glbl.v"

