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
    output reg reg_write_out,
    output reg mem_write_out,
    output reg mem_to_reg_out,
    output reg [4:0] rd_out,
    output reg [31:0] alu_result,
    output reg [31:0] write_data_out,
    output reg [31:0] pc_plus4_out,
    output wire [31:0] branch_target_out,  // Changed from reg to wire
    output wire branch_taken                // Changed from reg to wire
);

    wire [31:0] src_a, src_b;  // Changed to wire
    wire [31:0] alu_src_b;
    wire alu_zero;
    wire [31:0] alu_out;        // Changed to wire
    
    // Forwarding logic (combinational)
    wire [31:0] forward_a = (reg_write_mem && (rd_mem != 5'd0) && (rd_mem == rs1)) ? alu_res_mem :
                             (reg_write_wb && (rd_wb != 5'd0) && (rd_wb == rs1)) ? result_wb :
                             read1;
    
    wire [31:0] forward_b = (reg_write_mem && (rd_mem != 5'd0) && (rd_mem == rs2)) ? alu_res_mem :
                             (reg_write_wb && (rd_wb != 5'd0) && (rd_wb == rs2)) ? result_wb :
                             read2;
    
    assign alu_src_b = alu_src_in ? imm : forward_b;
    assign branch_target_out = pc_in + imm;
    assign branch_taken = branch_in && alu_zero;
    
    alu_full alu_inst (
        .src_a(forward_a),
        .src_b(alu_src_b),
        .alu_control(alu_ctrl_in),
        .result(alu_out),
        .zero_flag(alu_zero)
    );
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            reg_write_out <= 1'b0;
            mem_write_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
            rd_out <= 5'd0;
            alu_result <= 32'd0;
            write_data_out <= 32'd0;
            pc_plus4_out <= 32'd0;
        end else begin
            reg_write_out <= reg_write_in;
            mem_write_out <= mem_write_in;
            mem_to_reg_out <= mem_to_reg_in;
            rd_out <= rd_in;
            alu_result <= alu_out;
            write_data_out <= forward_b;
            pc_plus4_out <= pc_plus4_in;
        end
    end

endmodule