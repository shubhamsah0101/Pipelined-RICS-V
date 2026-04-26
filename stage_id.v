module stage_id(
    input wire clk,
    input wire rst,
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
    output reg [31:0] pc_plus4_ex
);

    wire reg_write_id, alu_src_id, mem_write_id, mem_to_reg_id, branch_id;
    wire [1:0] imm_src_id;
    wire [2:0] alu_ctrl_id;
    wire [31:0] read1_id, read2_id, imm_id;
    
    ctrl_unit control (
        .opcode(instr_in[6:0]),
        .funct3(instr_in[14:12]),
        .funct7(instr_in[31:25]),
        .reg_write(reg_write_id),
        .alu_src(alu_src_id),
        .mem_write(mem_write_id),
        .mem_to_reg(mem_to_reg_id),
        .branch(branch_id),
        .alu_control(alu_ctrl_id)
    );
    
    reg_file register_file (
        .clk(clk),
        .rst(rst),
        .write_en(reg_write_wb),
        .write_addr(write_addr_wb),
        .write_data(write_data_wb),
        .read_addr1(instr_in[19:15]),
        .read_addr2(instr_in[24:20]),
        .read_data1(read1_id),
        .read_data2(read2_id)
    );
    
    sign_ext sign_extend (
        .instr(instr_in),
        .imm_src(imm_src_id),
        .imm_ext(imm_id)
    );
    
    // ImmSrc generation based on opcode
    assign imm_src_id = (instr_in[6:0] == 7'b0100011) ? 2'b01 :
                        (instr_in[6:0] == 7'b1100011) ? 2'b10 : 2'b00;
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            reg_write_ex <= 1'b0;
            alu_src_ex <= 1'b0;
            mem_write_ex <= 1'b0;
            mem_to_reg_ex <= 1'b0;
            branch_ex <= 1'b0;
            alu_ctrl_ex <= 3'b000;
            read1_ex <= 32'd0;
            read2_ex <= 32'd0;
            imm_ex <= 32'd0;
            rd_ex <= 5'd0;
            rs1_ex <= 5'd0;
            rs2_ex <= 5'd0;
            pc_ex <= 32'd0;
            pc_plus4_ex <= 32'd0;
        end else begin
            reg_write_ex <= reg_write_id;
            alu_src_ex <= alu_src_id;
            mem_write_ex <= mem_write_id;
            mem_to_reg_ex <= mem_to_reg_id;
            branch_ex <= branch_id;
            alu_ctrl_ex <= alu_ctrl_id;
            read1_ex <= read1_id;
            read2_ex <= read2_id;
            imm_ex <= imm_id;
            rd_ex <= instr_in[11:7];
            rs1_ex <= instr_in[19:15];
            rs2_ex <= instr_in[24:20];
            pc_ex <= pc_in;
            pc_plus4_ex <= pc_plus4_in;
        end
    end

endmodule