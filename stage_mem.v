module stage_mem(
    input wire clk,
    input wire rst,
    input wire reg_write_in,
    input wire mem_to_reg_in,
    input wire mem_write_in,
    input wire [4:0] rd_in,
    input wire [31:0] alu_result_in,
    input wire [31:0] write_data_in,
    input wire [31:0] pc_plus4_in,
    output reg reg_write_out,
    output reg mem_to_reg_out,
    output reg [4:0] rd_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] pc_plus4_out
);
    // Simple data memory simulation (for waveform verification)
    reg [31:0] data_mem [0:255];
    integer i;
    
    initial begin
        for (i = 0; i < 256; i = i + 1)
            data_mem[i] = 32'd0;
    end
    
    always @(posedge clk) begin
        if (mem_write_in)
            data_mem[alu_result_in[9:2]] <= write_data_in;
    end
    
    always @(posedge clk) begin
        if (rst) begin
            reg_write_out <= 0; mem_to_reg_out <= 0; rd_out <= 0;
            alu_result_out <= 0; pc_plus4_out <= 0;
        end else begin
            reg_write_out <= reg_write_in; mem_to_reg_out <= mem_to_reg_in;
            rd_out <= rd_in; alu_result_out <= alu_result_in; pc_plus4_out <= pc_plus4_in;
        end
    end
endmodule