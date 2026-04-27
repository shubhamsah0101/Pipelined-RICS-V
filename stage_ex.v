module stage_ex(
    input wire clk,
    input wire rst,
    input wire reg_write_in,
    input wire alu_src_in,
    input wire mem_write_in,
    input wire mem_to_reg_in,
    input wire branch_in,
    input wire [2:0] alu_ctrl_in,
    input wire [31:0] read1,
    input wire [31:0] read2,
    input wire [31:0] imm,
    input wire [4:0] rd_in,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [31:0] pc_in,
    input wire [31:0] pc_plus4_in,
    input wire [31:0] alu_res_mem,
    input wire [31:0] result_wb,
    input wire reg_write_mem,
    input wire reg_write_wb,
    input wire [4:0] rd_mem,
    input wire [4:0] rd_wb,
    input wire [1:0] forward_a,
    input wire [1:0] forward_b,
    output reg reg_write_out,
    output reg mem_write_out,
    output reg mem_to_reg_out,
    output reg [4:0] rd_out,
    output reg [31:0] alu_result,
    output reg [31:0] write_data_out,
    output reg [31:0] pc_plus4_out,
    output wire [31:0] branch_target,
    output wire branch_taken
);
    wire [31:0] src_a, src_b;
    wire [31:0] alu_src_b;
    wire alu_zero;
    wire [31:0] alu_out;
    
    // Forwarding muxes
    assign src_a = (forward_a == 2'b10) ? alu_res_mem : 
                   (forward_a == 2'b01) ? result_wb : read1;
    assign src_b = (forward_b == 2'b10) ? alu_res_mem : 
                   (forward_b == 2'b01) ? result_wb : read2;
    
    assign alu_src_b = alu_src_in ? imm : src_b;
    assign branch_target = pc_in + imm;
    
    alu_full alu(.src_a(src_a), .src_b(alu_src_b), .alu_control(alu_ctrl_in),
                 .result(alu_out), .zero_flag(alu_zero));
    
    assign branch_taken = branch_in && alu_zero;
    
    always @(posedge clk) begin
        if (rst) begin
            reg_write_out <= 0; mem_write_out <= 0; mem_to_reg_out <= 0;
            rd_out <= 0; alu_result <= 0; write_data_out <= 0; pc_plus4_out <= 0;
        end else begin
            reg_write_out <= reg_write_in; mem_write_out <= mem_write_in;
            mem_to_reg_out <= mem_to_reg_in; rd_out <= rd_in;
            alu_result <= alu_out; write_data_out <= src_b; pc_plus4_out <= pc_plus4_in;
        end
    end
endmodule