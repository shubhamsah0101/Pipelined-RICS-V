module alu_full(
    input wire [31:0] src_a,
    input wire [31:0] src_b,
    input wire [2:0] alu_control,
    output reg [31:0] result,
    output reg zero_flag
);

    reg [32:0] temp_result;

    always @(*) begin
        case (alu_control)
            3'b000: begin  // ADD
                temp_result = {1'b0, src_a + src_b};
                result = temp_result[31:0];
                zero_flag = (result == 32'd0);
            end
            
            3'b001: begin  // SUB
                temp_result = {1'b0, src_a - src_b};
                result = temp_result[31:0];
                zero_flag = (result == 32'd0);
            end
            
            3'b010: begin  // AND
                result = src_a & src_b;
                zero_flag = (result == 32'd0);
            end
            
            3'b011: begin  // OR
                result = src_a | src_b;
                zero_flag = (result == 32'd0);
            end
            
            3'b100: begin  // XOR
                result = src_a ^ src_b;
                zero_flag = (result == 32'd0);
            end
            
            3'b101: begin  // SLT (set less than)
                result = ($signed(src_a) < $signed(src_b)) ? 32'd1 : 32'd0;
                zero_flag = (result == 32'd0);
            end
            
            default: begin
                result = 32'd0;
                zero_flag = 1'b0;
            end
        endcase
    end

endmodule