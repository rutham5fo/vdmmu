`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:30:49 PM
// Design Name: 
// Module Name: vmap_gen
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


module vmap_gen #(
        parameter TEST_EN           = 0,
        parameter HEAP_SIZE         = 32,                   // Number of BRAM elements in the heap
        parameter HEAP_W            = $clog2(HEAP_SIZE)
    )(
        input wire                          clk,
        input wire                          reset_n,
        input wire  [HEAP_W*HEAP_SIZE-1:0]  full_list_dest,
        input wire  [HEAP_W*HEAP_SIZE-1:0]  free_list_dest,
        input wire  [HEAP_SIZE-1:0]         full_list_valid,
        input wire  [HEAP_SIZE-1:0]         free_list_valid,
        input wire  [HEAP_SIZE-1:0]         manager_wr_valid,
        input wire                          manager_status_in,
        input wire                          vmap_gen_en,
        
        output wire [HEAP_W*HEAP_SIZE-1:0]  vtp_map,            // Virtual to physical map output
        output wire [HEAP_SIZE-1:0]         vtp_status          // Status of the memory unit -> 1 = allocated, 0 = free
    );
    
    localparam NODES                = HEAP_SIZE/2;
    localparam STAGES               = $clog2(HEAP_SIZE);
    
    wire    [HEAP_W*HEAP_SIZE-1:0]      current_data;
    wire    [HEAP_SIZE-1:0]             current_status;
    wire    [HEAP_W*HEAP_SIZE-1:0]      full_new_data;
    wire    [HEAP_W-1:0]                full_new_data_unpkd[0:HEAP_SIZE-1];
    wire    [HEAP_W*HEAP_SIZE-1:0]      free_new_data;
    wire    [HEAP_W-1:0]                free_new_data_unpkd[0:HEAP_SIZE-1];
    wire    [HEAP_SIZE-1:0]             full_new_status;
    wire    [HEAP_SIZE-1:0]             free_new_status;
    wire    [HEAP_SIZE-1:0]             full_new_valid;
    wire    [HEAP_SIZE-1:0]             free_new_valid;
    
    reg     [HEAP_W-1:0]                vtp_map_regs[0:HEAP_SIZE-1];
    reg     [HEAP_SIZE-1:0]             vtp_status_regs;
    reg     [HEAP_W-1:0]                vtp_map_drv[0:HEAP_SIZE-1];
    reg     [HEAP_SIZE-1:0]             vtp_status_drv;
    
    genvar i;
    integer k;
    
    assign vtp_status = vtp_status_regs;
        
    generate
        for (i = 0; i < HEAP_SIZE; i = i+1) begin
            assign current_data[i*HEAP_W +: HEAP_W] = vtp_map_regs[i];
            assign current_status[i] = vtp_status_regs[i];
            assign full_new_data_unpkd[i] = full_new_data[i*HEAP_W +: HEAP_W];
            assign free_new_data_unpkd[i] = free_new_data[i*HEAP_W +: HEAP_W];
            
            assign vtp_map[i*HEAP_W +: HEAP_W] = vtp_map_regs[i];
            
            always @(*) begin
                case ({full_new_valid[i], free_new_valid[i]})
                    2'b01   : begin
                        vtp_map_drv[i] = free_new_data_unpkd[i];
                        vtp_status_drv[i] = free_new_status[i];
                    end
                    2'b10   : begin
                        vtp_map_drv[i] = full_new_data_unpkd[i];
                        vtp_status_drv[i] = full_new_status[i];
                    end
                    default : begin
                        vtp_map_drv[i] = vtp_map_regs[i];
                        vtp_status_drv[i] = (manager_wr_valid[i] && vmap_gen_en) ? manager_status_in : vtp_status_regs[i];
                    end
                endcase
            end
        end
    endgenerate
    
    reverse_butterfly #(
        .TEST_EN(TEST_EN),
        .INPUTS(HEAP_SIZE),
        .NODES(NODES),
        .ADDR_W(HEAP_W),
        .DATA_W(HEAP_W),
        .STAGES(STAGES)
    ) full_list_mapper_i (
        .addr_in(full_list_dest),
        .data_in(current_data),
        .status_in(current_status),
        .valid_in(full_list_valid),
        
        .data_out(full_new_data),
        .status_out(full_new_status),
        .valid_out(full_new_valid)
    );
    
    reverse_butterfly #(
        .TEST_EN(TEST_EN),
        .INPUTS(HEAP_SIZE),
        .NODES(NODES),
        .ADDR_W(HEAP_W),
        .DATA_W(HEAP_W),
        .STAGES(STAGES)
    ) free_list_mapper_i (
        .addr_in(free_list_dest),
        .data_in(current_data),
        .status_in(current_status),
        .valid_in(free_list_valid),
        
        .data_out(free_new_data),
        .status_out(free_new_status),
        .valid_out(free_new_valid)
    );
    
    always @(posedge clk) begin
        if (!reset_n) begin
            for (k = 0; k < HEAP_SIZE; k = k+1) begin
                vtp_map_regs[k] <= k;
                vtp_status_regs[k] <= 1'b0;
            end
        end
        else begin
            for (k = 0; k < HEAP_SIZE; k = k+1) begin
                vtp_map_regs[k] <= vtp_map_drv[k];
                vtp_status_regs[k] <= vtp_status_drv[k];
            end
        end
    end    
    
endmodule
