module stage_wb(
    input wire clk,
    input wire rst,
    input wire reg_write_in,
    input wire mem_to_reg_in,
    input wire [4:0] rd_in,
    input wire [31:0] alu_result,
    input wire [31:0] pc_plus4,
    output reg reg_write_out,
    output reg [4:0] rd_out,
    output reg [31:0] result_out
);
    // For addition-only, mem_to_reg is always 0, so we use alu_result
    // If mem_to_reg was 1, we'd use read data from memory
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            reg_write_out <= 1'b0;
            rd_out <= 5'd0;
            result_out <= 32'd0;
        end else begin
            reg_write_out <= reg_write_in;
            rd_out <= rd_in;
            result_out <= mem_to_reg_in ? 32'd0 : alu_result;  // mem data = 0 for simplicity
        end
    end

endmodule