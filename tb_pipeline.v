`timescale 1ns / 1ps

module tb_pipeline();

    reg clk;
    reg rst;
    
    // Pipeline stage signals for waveform viewing
    wire [31:0] pc_if, instr_if;
    wire [31:0] read1_id, read2_id, imm_id;
    wire [31:0] alu_res_ex, alu_res_mem;
    wire [31:0] result_wb;
    wire [4:0] rd_ex, rd_mem, rd_wb;
    wire [2:0] alu_ctrl_ex;
    
    // Instantiate top module
    pipeline_top dut (
        .clk(clk),
        .rst(rst)
    );
    
    // Clock: 50MHz period (20ns)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    // Test sequence
    initial begin
        $display("============================================================");
        $display("5-Stage Pipelined RISC-V Processor");
        $display("Demonstrating: 2 + 2 = 4");
        $display("ALU supports all operations (ADD, SUB, AND, OR, XOR, SLT)");
        $display("============================================================");
        
        rst = 0;
        $display("Time=%0t: [RESET] Processor reset", $time);
        #25;
        
        rst = 1;
        $display("Time=%0t: [START] Pipeline running", $time);
        $display("============================================================");
        $display("Instructions in memory:");
        $display("  [0] addi x5, x0, 2");
        $display("  [1] addi x6, x0, 2");
        $display("  [2] add  x7, x5, x6");
        $display("============================================================");
        
        #500;
        
        $display("============================================================");
        $display("Time=%0t: [SIMULATION COMPLETE]", $time);
        $display("Expected result: x7 = 4");
        $display("============================================================");
        $finish;
    end
    
    // Dump waveforms
    initial begin
        $dumpfile("pipeline_waves.vcd");
        $dumpvars(0, tb_pipeline);
    end
    
    // Monitor pipeline progression
    initial begin
        $monitor("TIME=%0t | IF:PC=%0d | ID:RS1=%0d RS2=%0d | EX:ALU_CTRL=%b RES=%0d | MEM:RES=%0d | WB:RES=%0d",
                 $time, dut.if_stage.pc_out,
                 dut.id_stage.read1_ex, dut.id_stage.read2_ex,
                 dut.ex_stage.alu_ctrl_in, dut.ex_stage.alu_result,
                 dut.mem_stage.alu_result_out,
                 dut.wb_stage.result_out);
    end
    
    // Assign signals for GTKWave
    assign pc_if = dut.if_stage.pc_out;
    assign instr_if = dut.if_stage.instr_out;
    assign read1_id = dut.id_stage.read1_ex;
    assign read2_id = dut.id_stage.read2_ex;
    assign imm_id = dut.id_stage.imm_ex;
    assign alu_ctrl_ex = dut.ex_stage.alu_ctrl_in;
    assign alu_res_ex = dut.ex_stage.alu_result;
    assign alu_res_mem = dut.mem_stage.alu_result_out;
    assign result_wb = dut.wb_stage.result_out;
    assign rd_ex = dut.ex_stage.rd_out;
    assign rd_mem = dut.mem_stage.rd_out;
    assign rd_wb = dut.wb_stage.rd_out;

endmodule