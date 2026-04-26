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
    // Data memory is bypassed for addition-only demonstration
    // mem_write is ignored
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            reg_write_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
            rd_out <= 5'd0;
            alu_result_out <= 32'd0;
            pc_plus4_out <= 32'd0;
        end else begin
            reg_write_out <= reg_write_in;
            mem_to_reg_out <= mem_to_reg_in;
            rd_out <= rd_in;
            alu_result_out <= alu_result_in;
            pc_plus4_out <= pc_plus4_in;
        end
    end

endmodule