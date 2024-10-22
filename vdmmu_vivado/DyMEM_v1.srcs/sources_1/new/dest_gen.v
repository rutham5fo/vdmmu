`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 12:26:58 PM
// Design Name: 
// Module Name: dest_gen
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


module dest_gen #(
        parameter HEAP_SIZE             = 32,
        parameter HEAP_W                = $clog2(HEAP_SIZE)
    )(
        input wire                          clk,
        input wire                          reset_n,
        input wire  [HEAP_W:0]              free_ptr,               // Points to the first free memory unit
        input wire  [HEAP_W-1:0]            dealloc_base,
        input wire  [HEAP_W:0]              dealloc_size,
        input wire  [HEAP_SIZE-1:0]         vtp_status_in,
        input wire                          dest_gen_en,
        
        output wire [HEAP_W*HEAP_SIZE-1:0]  full_list_dest,
        output wire [HEAP_W*HEAP_SIZE-1:0]  free_list_dest,
        output wire [HEAP_SIZE-1:0]         full_list_valid,
        output wire [HEAP_SIZE-1:0]         free_list_valid
    );
    
    wire    [HEAP_W:0]                  full_shift_delim;
    wire    [HEAP_W-1:0]                free_shift_delim;
    wire    [HEAP_W:0]                  full_shift_val;
    wire    [HEAP_W-1:0]                free_shift_val;
            
    reg     [HEAP_W-1:0]                full_dest_regs[0:HEAP_SIZE-1];
    reg     [HEAP_W-1:0]                free_dest_regs[0:HEAP_SIZE-1];
    reg     [HEAP_SIZE-1:0]             full_valid_regs;
    reg     [HEAP_SIZE-1:0]             free_valid_regs;
    
    genvar i;
    integer k;
    
    assign full_shift_delim = dealloc_base + dealloc_size;
    assign free_shift_delim = free_ptr - 1;
    assign full_shift_val = dealloc_size;
    assign free_shift_val = free_ptr - full_shift_delim;
    
    assign full_list_valid = full_valid_regs;
    assign free_list_valid = free_valid_regs;
    
    generate
        for (i = 0; i < HEAP_SIZE; i = i+1) begin
            assign full_list_dest[i*HEAP_W +: HEAP_W] = full_dest_regs[i];
            assign free_list_dest[i*HEAP_W +: HEAP_W] = free_dest_regs[i];
        end
    endgenerate
    
    always @(posedge clk) begin
        if (!reset_n) begin
            for (k = 0; k < HEAP_SIZE; k = k+1) begin
                full_dest_regs[k] <= k;
                free_dest_regs[k] <= k;
                full_valid_regs[k] <= 1'b0;
                free_valid_regs[k] <= 1'b0;
            end
        end
        else begin
            for (k = 0; k < HEAP_SIZE; k = k+1) begin
                full_dest_regs[k] <= (dest_gen_en && k >= full_shift_delim) ? k - full_shift_val : k;
                free_dest_regs[k] <= (dest_gen_en && k <= free_shift_delim) ? k + free_shift_val : k;
                full_valid_regs[k] <= (dest_gen_en && vtp_status_in[k]) ? 1'b1 : 1'b0;
                free_valid_regs[k] <= (dest_gen_en && !vtp_status_in[k]) ? 1'b1 : 1'b0;
            end
        end
    end
    
endmodule
