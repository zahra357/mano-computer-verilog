`timescale 1ns / 1ps

module TopModule_tb;

    // Inputs
    reg clk;
    reg rst;
    reg halt;
    
    // Outputs
    wire [15:0] debug_mem0;
    wire [15:0] debug_mem1;
    wire [15:0] debug_mem2;
    wire [15:0] debug_mem3;
    wire [15:0] debug_mem4;
    wire [11:0] AR_reg;
    wire [15:0] DR_reg;
    wire [15:0] IR_reg;
    wire [11:0] PC_reg;
    wire [15:0] AC_reg;
    wire [15:0] TR_reg;
    wire E_reg;
    wire [2:0] step;
    wire HALT;
    
    // Instantiate the Unit Under Test (UUT)
    TopModule uut (
        .clk(clk),
        .rst(rst),
        .debug_mem0(debug_mem0),
        .debug_mem1(debug_mem1),
        .debug_mem2(debug_mem2),
        .debug_mem3(debug_mem3),
        .debug_mem4(debug_mem4),
        .AR_reg(AR_reg),
        .DR_reg(DR_reg),
        .IR_reg(IR_reg),
        .PC_reg(PC_reg),
        .AC_reg(AC_reg),
        .TR_reg(TR_reg),
        .E_reg(E_reg),
        .step(step),
        .HALT(HALT)
    );
    
    // Clock generator
    always begin
        #5 clk = ~clk; // 10ns period (100MHz)
    end
    
    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 0;
        halt = 0;
        
        // Reset sequence
        #5 rst = 1;      // Reset active at 5ns
        #10 rst = 0;     // Reset deactive at 15ns
        
        // Display initial memory values
        $display("Time = %0t ns", $time);
        $display("Initial Memory Values:");
        $display("mem0 = %h", debug_mem0);
        $display("mem1 = %h", debug_mem1);
        $display("mem2 = %h", debug_mem2);
        $display("mem3 = %h", debug_mem3);
        $display("mem4 = %h", debug_mem4);
        
        // Wait until 1500ns
        #3000;
        
        // Display final memory values
        $display("\nTime = %0t ns", $time);
        $display("Final Memory Values:");
        $display("mem0 = %h", debug_mem0);
        $display("mem1 = %h", debug_mem1);
        $display("mem2 = %h", debug_mem2);
        $display("mem3 = %h", debug_mem3);
        $display("mem4 = %h", debug_mem4);
        
        // Check halt condition
        if (halt) begin
            #5 rst = 1;
            $display("\nHALT signal detected. System reset at %0t ns", $time);
        end
        
        // End simulation
        $display("\nSimulation finished at %0t ns", $time);
        $finish;
    end
    
endmodule
