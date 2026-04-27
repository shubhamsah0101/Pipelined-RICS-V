module hazard_unit(
    input wire rst,
    // EX stage inputs
    input wire [4:0] rs1_ex,
    input wire [4:0] rs2_ex,
    // MEM stage inputs
    input wire reg_write_mem,
    input wire [4:0] rd_mem,
    // WB stage inputs
    input wire reg_write_wb,
    input wire [4:0] rd_wb,
    // Branch detection from ID stage
    input wire branch_id,
    // Outputs
    output reg [1:0] forward_a_ex,
    output reg [1:0] forward_b_ex,
    output reg stall_pc,
    output reg flush_if_id
);
    // Forwarding logic (from paper)
    always @(*) begin
        // Default values
        forward_a_ex = 2'b00;
        forward_b_ex = 2'b00;
        stall_pc = 1'b0;
        flush_if_id = 1'b0;
        
        if (!rst) begin
            forward_a_ex = 2'b00;
            forward_b_ex = 2'b00;
            stall_pc = 1'b0;
            flush_if_id = 1'b0;
        end else begin
            // Forwarding from MEM stage (higher priority)
            if (reg_write_mem && (rd_mem != 5'd0) && (rd_mem == rs1_ex))
                forward_a_ex = 2'b10;
            if (reg_write_mem && (rd_mem != 5'd0) && (rd_mem == rs2_ex))
                forward_b_ex = 2'b10;
            
            // Forwarding from WB stage (lower priority)
            if (reg_write_wb && (rd_wb != 5'd0) && (rd_wb == rs1_ex) && (forward_a_ex == 2'b00))
                forward_a_ex = 2'b01;
            if (reg_write_wb && (rd_wb != 5'd0) && (rd_wb == rs2_ex) && (forward_b_ex == 2'b00))
                forward_b_ex = 2'b01;
            
            // Branch hazard - stall for 1 cycle (simplified from paper's 3 cycles)
            if (branch_id)
                stall_pc = 1'b1;
        end
    end
endmodule