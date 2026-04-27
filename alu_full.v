module alu_full(
    input wire [31:0] src_a,
    input wire [31:0] src_b,
    input wire [2:0] alu_control,
    output reg [31:0] result,
    output reg zero_flag
);
    always @(*) begin
        case (alu_control)
            3'b000: result = src_a + src_b;
            3'b001: result = src_a - src_b;
            3'b010: result = src_a & src_b;
            3'b011: result = src_a | src_b;
            3'b100: result = src_a ^ src_b;
            3'b101: result = ($signed(src_a) < $signed(src_b)) ? 32'd1 : 32'd0;
            default: result = 32'd0;
        endcase
        zero_flag = (result == 32'd0);
    end
endmodule