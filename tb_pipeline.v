`timescale 1ns / 1ps

module tb_pipeline();

    reg clk;
    reg rst;
    
    wire [31:0] pc_if, instr_if;
    wire [31:0] read1_id, read2_id, imm_id;
    wire [31:0] alu_res_ex, alu_res_mem;
    wire [31:0] result_wb;
    wire [4:0] rd_ex, rd_mem, rd_wb;
    wire [2:0] alu_ctrl_ex;
    
    pipeline_top dut (
        .clk(clk),
        .rst(rst)
    );
    
    // Clock: 50MHz period (20ns)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    // Test sequence - FIXED reset timing
    initial begin
        $display("============================================================");
        $display("5-Stage Pipelined RISC-V Processor");
        $display("Demonstrating: 2 + 2 = 4");
        $display("============================================================");
        
        // Initialize reset
        rst = 1;  // Start with reset asserted
        $display("Time=%0t: Reset ASSERTED", $time);
        
        // Hold reset for 2 clock cycles (40ns)
        #40;
        
        // Release reset
        rst = 0;  // Active low reset - 0 means normal operation
        $display("Time=%0t: Reset RELEASED - Pipeline starting", $time);
        $display("============================================================");
        
        // Run for 500ns
        #500;
        
        $display("============================================================");
        $display("Time=%0t: Simulation complete!", $time);
        $display("============================================================");
        $finish;
    end
    
    // VCD dump for GTKWave
    initial begin
        $dumpfile("pipeline_waves.vcd");
        $dumpvars(0, tb_pipeline);
        $display("VCD file: pipeline_waves.vcd");
    end
    
    // Monitor pipeline progression
    initial begin
        $monitor("TIME=%0t | rst=%b | PC=%0d | ALU_EX=%0d | WB=%0d",
                 $time, rst, dut.if_stage.pc_out,
                 dut.ex_stage.alu_result, dut.wb_stage.result_out);
    end

endmodule