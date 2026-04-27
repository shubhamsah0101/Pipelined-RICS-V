module stage_if(
    input wire clk,
    input wire rst,
    input wire stall,
    input wire flush,
    input wire branch_taken,
    input wire [31:0] branch_target,
    output reg [31:0] pc_out,
    output reg [31:0] instr_out,
    output reg [31:0] pc_plus4_out
);
    reg [31:0] pc;
    reg [31:0] imem [0:63];
    integer i;
    
    wire [31:0] pc_next;
    wire [31:0] pc_plus4;
    wire [31:0] instr;
    
    assign pc_plus4 = pc + 32'd4;
    assign pc_next = (branch_taken && !stall) ? branch_target : pc_plus4;
    assign instr = (flush) ? 32'd0 : imem[pc[7:2]];
    
    always @(posedge clk) begin
        if (rst) begin
            pc <= 32'd0;
            pc_out <= 32'd0;
            instr_out <= 32'd0;
            pc_plus4_out <= 32'd0;
        end else if (!stall) begin
            pc <= pc_next;
            pc_out <= pc;
            instr_out <= instr;
            pc_plus4_out <= pc_plus4;
        end
    end
    
    initial begin
		// 2 + 2 = 4 Program
		
		// addi x5, x0, 2  -> x5 = 2
		// Binary: 000000000010_00000_000_00101_0010011
		// Hex: 0x00200293
		imem[0] = 32'h00200293;  // NOT 02020293!
		
		// addi x6, x0, 2  -> x6 = 2
		// Binary: 000000000010_00000_000_00110_0010011
		// Hex: 0x00200313
		imem[1] = 32'h00200313;
		
		// add x7, x5, x6  -> x7 = 2 + 2 = 4
		// Binary: 0000000_00110_00101_000_00111_0110011
		// Hex: 0x006283B3
		imem[2] = 32'h006283B3;
		
		for (i = 3; i < 64; i = i + 1)
			imem[i] = 32'd0;
	end
	
	
endmodule