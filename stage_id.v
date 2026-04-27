module stage_id(
    input wire clk,
    input wire rst,
    input wire flush,
    input wire [31:0] instr_in,
    input wire [31:0] pc_in,
    input wire [31:0] pc_plus4_in,
    input wire reg_write_wb,
    input wire [4:0] write_addr_wb,
    input wire [31:0] write_data_wb,
    output reg reg_write_ex,
    output reg alu_src_ex,
    output reg mem_write_ex,
    output reg mem_to_reg_ex,
    output reg branch_ex,
    output reg [2:0] alu_ctrl_ex,
    output reg [31:0] read1_ex,
    output reg [31:0] read2_ex,
    output reg [31:0] imm_ex,
    output reg [4:0] rd_ex,
    output reg [4:0] rs1_ex,
    output reg [4:0] rs2_ex,
    output reg [31:0] pc_ex,
    output reg [31:0] pc_plus4_ex,
    output reg branch_detected
);
    wire reg_write, alu_src, mem_write, mem_to_reg, branch;
    wire [2:0] alu_ctrl;
    wire [31:0] read1, read2, imm;
    wire [1:0] imm_src;
    wire branch_comp_out;
    
    ctrl_unit ctrl(.opcode(instr_in[6:0]), .funct3(instr_in[14:12]), .funct7(instr_in[31:25]),
                   .reg_write(reg_write), .alu_src(alu_src), .mem_write(mem_write),
                   .mem_to_reg(mem_to_reg), .branch(branch), .alu_control(alu_ctrl));
    
    reg_file rf(.clk(clk), .rst(rst), .write_en(reg_write_wb), .write_addr(write_addr_wb),
                .write_data(write_data_wb), .read_addr1(instr_in[19:15]), .read_addr2(instr_in[24:20]),
                .read_data1(read1), .read_data2(read2));
    
    branch_comp bc(.reg_a(read1), .reg_b(read2), .funct3(instr_in[14:12]), .branch_taken(branch_comp_out));
    
    assign imm_src = (instr_in[6:0] == 7'b0100011) ? 2'b01 : 
                     (instr_in[6:0] == 7'b1100011) ? 2'b10 : 2'b00;
    sign_ext se(.instr(instr_in), .imm_src(imm_src), .imm_ext(imm));
    
    always @(posedge clk) begin
        if (rst) begin
            reg_write_ex <= 0; alu_src_ex <= 0; mem_write_ex <= 0; mem_to_reg_ex <= 0;
            branch_ex <= 0; alu_ctrl_ex <= 0; read1_ex <= 0; read2_ex <= 0;
            imm_ex <= 0; rd_ex <= 0; rs1_ex <= 0; rs2_ex <= 0;
            pc_ex <= 0; pc_plus4_ex <= 0; branch_detected <= 0;
        end else if (flush) begin
            reg_write_ex <= 0; alu_src_ex <= 0; mem_write_ex <= 0; mem_to_reg_ex <= 0;
            branch_ex <= 0; alu_ctrl_ex <= 0; read1_ex <= 0; read2_ex <= 0;
            imm_ex <= 0; rd_ex <= 0; rs1_ex <= 0; rs2_ex <= 0;
            pc_ex <= 0; pc_plus4_ex <= 0; branch_detected <= 0;
        end else begin
            reg_write_ex <= reg_write; alu_src_ex <= alu_src; mem_write_ex <= mem_write;
            mem_to_reg_ex <= mem_to_reg; branch_ex <= branch; alu_ctrl_ex <= alu_ctrl;
            read1_ex <= read1;  // This passes the register value
            read2_ex <= read2;  // This passes the register value
            imm_ex <= imm;
            rd_ex <= instr_in[11:7]; 
            rs1_ex <= instr_in[19:15]; 
            rs2_ex <= instr_in[24:20];
            pc_ex <= pc_in; 
            pc_plus4_ex <= pc_plus4_in;
            branch_detected <= branch && branch_comp_out;
        end
    end
endmodule