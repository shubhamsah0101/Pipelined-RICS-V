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
    always @(posedge clk) begin
        if (rst) begin
            reg_write_out <= 0; rd_out <= 0; result_out <= 0;
        end else begin
            reg_write_out <= reg_write_in; rd_out <= rd_in;
            // For load instructions, would use memory read data
            result_out <= mem_to_reg_in ? 32'd0 : alu_result;
        end
    end
endmodule