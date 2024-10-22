# ==============================================================
# Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
# Tool Version Limit: 2023.10
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
# 
# ==============================================================
proc generate {drv_handle} {
    xdefine_include_file $drv_handle "xparameters.h" "XAp_axi" \
        "NUM_INSTANCES" \
        "DEVICE_ID" \
        "C_S_AXI_PS_RD_BASEADDR" \
        "C_S_AXI_PS_RD_HIGHADDR"

    xdefine_config_file $drv_handle "xap_axi_g.c" "XAp_axi" \
        "DEVICE_ID" \
        "C_S_AXI_PS_RD_BASEADDR"

    xdefine_canonical_xpars $drv_handle "xparameters.h" "XAp_axi" \
        "DEVICE_ID" \
        "C_S_AXI_PS_RD_BASEADDR" \
        "C_S_AXI_PS_RD_HIGHADDR"
}

