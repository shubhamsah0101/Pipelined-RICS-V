module stage_if(
    input wire clk,
    input wire rst,  // Active high: 1 = reset, 0 = normal
    input wire branch_taken,
    input wire [31:0] branch_target,
    output reg [31:0] pc_out,
    output reg [31:0] instr_out,
    output reg [31:0] pc_plus4_out
);

    reg [31:0] pc_current;
    reg [31:0] imem [0:63];
    
    wire [31:0] pc_next;
    wire [31:0] pc_plus4;
    wire [31:0] instr;
    
    assign pc_plus4 = pc_current + 32'd4;
    assign pc_next = branch_taken ? branch_target : pc_plus4;
    assign instr = (pc_current < 256 && !rst) ? imem[pc_current[7:2]] : 32'd0;
    
    always @(posedge clk) begin
        if (rst) begin
            pc_current <= 32'd0;
            pc_out <= 32'd0;
            instr_out <= 32'd0;
            pc_plus4_out <= 32'd0;
        end else begin
            pc_current <= pc_next;
            pc_out <= pc_current;
            instr_out <= instr;
            pc_plus4_out <= pc_plus4;
        end
    end
    
    initial begin
        // 2+2=4 program
        // addi x5, x0, 2  (x0=0, so x5=2)
        imem[0] = 32'b000000000010_00000_000_00101_0010011;
        // addi x6, x0, 2  (x6=2)
        imem[1] = 32'b000000000010_00000_000_00110_0010011;
        // add x7, x5, x6  (x7 = 2+2 = 4)
        imem[2] = 32'b0000000_00110_00101_000_00111_0110011;
        imem[3] = 32'd0;
        imem[4] = 32'd0;
        imem[5] = 32'd0;
        imem[6] = 32'd0;
        imem[7] = 32'd0;
    end

endmodule