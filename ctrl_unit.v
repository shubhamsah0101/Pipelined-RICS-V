module ctrl_unit(
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output wire reg_write,
    output wire alu_src,
    output wire mem_write,
    output wire mem_to_reg,
    output wire branch,
    output wire [2:0] alu_control
);

    wire [1:0] alu_op;
    
    ctrl_main main_dec (
        .opcode(opcode),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .alu_op(alu_op)
    );
    
    ctrl_alu alu_dec (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7(funct7),
        .alu_control(alu_control)
    );

endmodule