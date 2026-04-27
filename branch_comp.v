module branch_comp(
    input wire [31:0] reg_a,
    input wire [31:0] reg_b,
    input wire [2:0] funct3,
    output wire branch_taken
);
    wire eq = (reg_a == reg_b);
    wire lt = ($signed(reg_a) < $signed(reg_b));
    wire ltu = (reg_a < reg_b);
    
    assign branch_taken = (funct3 == 3'b000) ? eq :      // beq
                          (funct3 == 3'b001) ? ~eq :     // bne
                          (funct3 == 3'b100) ? lt :      // blt
                          (funct3 == 3'b101) ? ~lt :     // bge
                          (funct3 == 3'b110) ? ltu :     // bltu
                          (funct3 == 3'b111) ? ~ltu :    // bgeu
                          1'b0;
endmodule