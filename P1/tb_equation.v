`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:17:06 10/10/2022
// Design Name:   equation
// Module Name:   D:/CO/P1/tb_equation.v
// Project Name:  p1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: equation
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_equation;

    // Inputs
    reg        clk;
    reg        reset;
    reg  [7:0] in;

    // Outputs
    wire       out;

    // Instantiate the Unit Under Test (UUT)
    equation uut (
        .clk  (clk),
        .reset(reset),
        .in   (in),
        .out  (out)
    );

    initial begin
        // Initialize Inputs
        clk   = 1;
        reset = 1;
        #1;
        reset = 0;
        // Wait 100 ns for global reset to finish
        #9;
        in = "a";
        #10;
        in = "+";
        #10;
        in = "p";
        #10;
        in = "*";
        #10;
        in = "0";
        #10;
        in = "=";
        #10;
        in = "a";
        #10;
        in = "*";



        // Add stimulus here

    end
    always #5 clk = ~clk;
endmodule

