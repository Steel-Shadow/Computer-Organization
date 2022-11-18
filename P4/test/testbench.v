`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:00:24 11/12/2022
// Design Name:   mips
// Module Name:   D:/CO/P4/test_bench.v
// Project Name:  P4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_bench;

    // Inputs
    reg clk;
    reg reset;

    // Instantiate the Unit Under Test (UUT)
    mips uut (
        .clk  (clk),
        .reset(reset)
    );

    initial begin
        // Initialize Inputs
        clk   = 1;
        reset = 1;
        #5 reset = 0;
    end

    always #5 clk = ~clk;


endmodule
