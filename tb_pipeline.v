`timescale 1ns / 1ps

module tb_pipeline();

    reg clk;
    reg rst;
    
    pipeline_top dut (
        .clk(clk),
        .rst(rst)
    );
    
    // Clock: 50MHz (20ns period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    // Simple reset sequence
    initial begin
        $display("Starting simulation...");
        
        // Start with reset = 1 (active high)
        rst = 1;
        $display("Time=%0t: rst = 1 (RESET)", $time);
        
        // Wait 2 clock cycles (40ns)
        #40;
        
        // Release reset
        rst = 0;
        $display("Time=%0t: rst = 0 (RUNNING)", $time);
        
        // Run for 500ns
        #500;
        
        $display("Time=%0t: Simulation complete", $time);
        $finish;
    end
    
    // Dump waveforms
    initial begin
        $dumpfile("pipeline_waves.vcd");
        $dumpvars(0, tb_pipeline);
    end

endmodule