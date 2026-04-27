module pipeline_top(
    input wire clk,
    input wire rst
);
    // IF/ID signals
    wire [31:0] pc_if, instr_if, pc_plus4_if;
    
    // ID/EX signals
    wire reg_write_id, alu_src_id, mem_write_id, mem_to_reg_id, branch_id;
    wire [2:0] alu_ctrl_id;
    wire [31:0] read1_id, read2_id, imm_id, pc_id, pc_plus4_id;
    wire [4:0] rd_id, rs1_id, rs2_id;
    wire branch_detected;
    
    // EX/MEM signals
    wire reg_write_ex, mem_write_ex, mem_to_reg_ex;
    wire [4:0] rd_ex;
    wire [31:0] alu_res_ex, write_data_ex, pc_plus4_ex, branch_target_ex;
    wire branch_taken_ex;
    
    // MEM/WB signals
    wire reg_write_mem, mem_to_reg_mem;
    wire [4:0] rd_mem;
    wire [31:0] alu_res_mem, pc_plus4_mem;
    
    // WB signals
    wire reg_write_wb;
    wire [4:0] rd_wb;
    wire [31:0] result_wb;
    
    // Hazard unit signals
    wire [1:0] forward_a, forward_b;
    wire stall_pc, flush_if_id;
    
    // Hazard Control Unit
    hazard_unit hu(
        .rst(rst),
        .rs1_ex(rs1_id),
        .rs2_ex(rs2_id),
        .reg_write_mem(reg_write_mem),
        .rd_mem(rd_mem),
        .reg_write_wb(reg_write_wb),
        .rd_wb(rd_wb),
        .branch_id(branch_detected),
        .forward_a_ex(forward_a),
        .forward_b_ex(forward_b),
        .stall_pc(stall_pc),
        .flush_if_id(flush_if_id)
    );
    
    // Stage 1: Fetch
    stage_if if_stage(
        .clk(clk), .rst(rst), .stall(stall_pc), .flush(flush_if_id),
        .branch_taken(branch_taken_ex), .branch_target(branch_target_ex),
        .pc_out(pc_if), .instr_out(instr_if), .pc_plus4_out(pc_plus4_if)
    );
    
    // Stage 2: Decode
    stage_id id_stage(
        .clk(clk), .rst(rst), .flush(flush_if_id),
        .instr_in(instr_if), .pc_in(pc_if), .pc_plus4_in(pc_plus4_if),
        .reg_write_wb(reg_write_wb), .write_addr_wb(rd_wb), .write_data_wb(result_wb),
        .reg_write_ex(reg_write_id), .alu_src_ex(alu_src_id),
        .mem_write_ex(mem_write_id), .mem_to_reg_ex(mem_to_reg_id),
        .branch_ex(branch_id), .alu_ctrl_ex(alu_ctrl_id),
        .read1_ex(read1_id), .read2_ex(read2_id), .imm_ex(imm_id),
        .rd_ex(rd_id), .rs1_ex(rs1_id), .rs2_ex(rs2_id),
        .pc_ex(pc_id), .pc_plus4_ex(pc_plus4_id),
        .branch_detected(branch_detected)
    );
    
    // Stage 3: Execute
    stage_ex ex_stage(
        .clk(clk), .rst(rst),
        .reg_write_in(reg_write_id), .alu_src_in(alu_src_id),
        .mem_write_in(mem_write_id), .mem_to_reg_in(mem_to_reg_id),
        .branch_in(branch_id), .alu_ctrl_in(alu_ctrl_id),
        .read1(read1_id), .read2(read2_id), .imm(imm_id),
        .rd_in(rd_id), .rs1(rs1_id), .rs2(rs2_id),
        .pc_in(pc_id), .pc_plus4_in(pc_plus4_id),
        .alu_res_mem(alu_res_mem), .result_wb(result_wb),
        .reg_write_mem(reg_write_mem), .reg_write_wb(reg_write_wb),
        .rd_mem(rd_mem), .rd_wb(rd_wb),
        .forward_a(forward_a), .forward_b(forward_b),
        .reg_write_out(reg_write_ex), .mem_write_out(mem_write_ex),
        .mem_to_reg_out(mem_to_reg_ex), .rd_out(rd_ex),
        .alu_result(alu_res_ex), .write_data_out(write_data_ex),
        .pc_plus4_out(pc_plus4_ex), .branch_target(branch_target_ex),
        .branch_taken(branch_taken_ex)
    );
    
    // Stage 4: Memory
    stage_mem mem_stage(
        .clk(clk), .rst(rst),
        .reg_write_in(reg_write_ex), .mem_to_reg_in(mem_to_reg_ex),
        .mem_write_in(mem_write_ex), .rd_in(rd_ex),
        .alu_result_in(alu_res_ex), .write_data_in(write_data_ex),
        .pc_plus4_in(pc_plus4_ex),
        .reg_write_out(reg_write_mem), .mem_to_reg_out(mem_to_reg_mem),
        .rd_out(rd_mem), .alu_result_out(alu_res_mem),
        .pc_plus4_out(pc_plus4_mem)
    );
    
    // Stage 5: Writeback
    stage_wb wb_stage(
        .clk(clk), .rst(rst),
        .reg_write_in(reg_write_mem), .mem_to_reg_in(mem_to_reg_mem),
        .rd_in(rd_mem), .alu_result(alu_res_mem), .pc_plus4(pc_plus4_mem),
        .reg_write_out(reg_write_wb), .rd_out(rd_wb), .result_out(result_wb)
    );
endmodule