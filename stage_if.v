module stage_if(
    input wire clk,
    input wire rst,
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
    assign pc_next = (branch_taken && rst) ? branch_target : pc_plus4;
    assign instr = (rst && (pc_current >> 2) < 64) ? imem[pc_current[7:2]] : 32'd0;
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
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
        // addi x5, x0, 2
        imem[0] = 32'b000000000010_00000_000_00101_0010011;
        // addi x6, x0, 2  
        imem[1] = 32'b000000000010_00000_000_00110_0010011;
        // add x7, x5, x6
        imem[2] = 32'b0000000_00110_00101_000_00111_0110011;
        imem[3] = 32'd0;
        imem[4] = 32'd0;
    end

endmodule