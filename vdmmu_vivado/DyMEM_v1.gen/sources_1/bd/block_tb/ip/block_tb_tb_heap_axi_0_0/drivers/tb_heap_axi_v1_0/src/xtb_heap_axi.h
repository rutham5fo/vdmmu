// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XTB_HEAP_AXI_H
#define XTB_HEAP_AXI_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xtb_heap_axi_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
#ifdef SDT
    char *Name;
#else
    u16 DeviceId;
#endif
    u64 Ps_wr_BaseAddress;
} XTb_heap_axi_Config;
#endif

typedef struct {
    u64 Ps_wr_BaseAddress;
    u32 IsReady;
} XTb_heap_axi;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XTb_heap_axi_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XTb_heap_axi_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XTb_heap_axi_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XTb_heap_axi_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
#ifdef SDT
int XTb_heap_axi_Initialize(XTb_heap_axi *InstancePtr, UINTPTR BaseAddress);
XTb_heap_axi_Config* XTb_heap_axi_LookupConfig(UINTPTR BaseAddress);
#else
int XTb_heap_axi_Initialize(XTb_heap_axi *InstancePtr, u16 DeviceId);
XTb_heap_axi_Config* XTb_heap_axi_LookupConfig(u16 DeviceId);
#endif
int XTb_heap_axi_CfgInitialize(XTb_heap_axi *InstancePtr, XTb_heap_axi_Config *ConfigPtr);
#else
int XTb_heap_axi_Initialize(XTb_heap_axi *InstancePtr, const char* InstanceName);
int XTb_heap_axi_Release(XTb_heap_axi *InstancePtr);
#endif

void XTb_heap_axi_Start(XTb_heap_axi *InstancePtr);
u32 XTb_heap_axi_IsDone(XTb_heap_axi *InstancePtr);
u32 XTb_heap_axi_IsIdle(XTb_heap_axi *InstancePtr);
u32 XTb_heap_axi_IsReady(XTb_heap_axi *InstancePtr);
void XTb_heap_axi_EnableAutoRestart(XTb_heap_axi *InstancePtr);
void XTb_heap_axi_DisableAutoRestart(XTb_heap_axi *InstancePtr);

void XTb_heap_axi_Set_i_ps_trans_id(XTb_heap_axi *InstancePtr, u32 Data);
u32 XTb_heap_axi_Get_i_ps_trans_id(XTb_heap_axi *InstancePtr);
void XTb_heap_axi_Set_i_ps_wr_addr(XTb_heap_axi *InstancePtr, u32 Data);
u32 XTb_heap_axi_Get_i_ps_wr_addr(XTb_heap_axi *InstancePtr);
void XTb_heap_axi_Set_i_ps_wr_data(XTb_heap_axi *InstancePtr, u32 Data);
u32 XTb_heap_axi_Get_i_ps_wr_data(XTb_heap_axi *InstancePtr);
u32 XTb_heap_axi_Get_o_ps_wr_done(XTb_heap_axi *InstancePtr);
u32 XTb_heap_axi_Get_o_ps_wr_done_vld(XTb_heap_axi *InstancePtr);

void XTb_heap_axi_InterruptGlobalEnable(XTb_heap_axi *InstancePtr);
void XTb_heap_axi_InterruptGlobalDisable(XTb_heap_axi *InstancePtr);
void XTb_heap_axi_InterruptEnable(XTb_heap_axi *InstancePtr, u32 Mask);
void XTb_heap_axi_InterruptDisable(XTb_heap_axi *InstancePtr, u32 Mask);
void XTb_heap_axi_InterruptClear(XTb_heap_axi *InstancePtr, u32 Mask);
u32 XTb_heap_axi_InterruptGetEnabled(XTb_heap_axi *InstancePtr);
u32 XTb_heap_axi_InterruptGetStatus(XTb_heap_axi *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
