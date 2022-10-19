`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:49:09 10/15/2022
// Design Name:   intcheck
// Module Name:   D:/CO/P1/tb_intcheck.v
// Project Name:  p1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: intcheck
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_intcheck;

    // Inputs
    reg        clk;
    reg        reset;
    reg  [7:0] in;

    // Outputs
    wire       out;

    // Instantiate the Unit Under Test (UUT)
    intcheck uut (
        .clk  (clk),
        .reset(reset),
        .in   (in),
        .out  (out)
    );

    initial begin
        // Initialize Inputs
        clk   = 1;
        reset = 1;
        in    = 0;
        #4;
        reset = 0;
        #6;
        in = "i";#10;
        in = "n";#10;
        in = "t";#10;
        in = "	";#10;
        in ="	";#10;
        in = "A";#10;
        in = ";";#10;
        in = "i";#10;
        in = "n";#10;
        in = "t";#10;
        in = "	";#10;
        in = "b";#10;
        in = "_";#10;
        in = "1";#10;
        in = ",";#10;
        in = "c";#10;
        in = ";";#10;
        in ="	";#10;
        in = "i";#10;
        in = "n";#10;
        in = "t";#10;
        in ="	";#10;
        in = "i";#10;
        in = ",";#10;
        in = "i";#10;
        in = "n";#10;
        in = ",";#10;
        in = "i";#10;
        in = "n";#10;
        in = "t";#10;
        in = "d";#10;
        in = ";";#10;
        in = "i";#10;
        in = "n";#10;
        in = "t";#10;
        in = "	";#10;
        in = "e";#10;
        in = "[";#10;
        in = "2";#10;
        in = "]";#10;
        in = ";";#10;
        in = ";";#10;
        in = "i";#10;
        in = "n";#10;
        in = "t";#10;
        in ="	";#10;
        in = "f";#10;
        in = ",";#10;
        in = "i";#10;
        in = "n";#10;
        in = "t";#10;
        in = ",";#10;
        in = "g";#10;
        in = ";";#10;
        in = "i";#10;


        // Wait 100 ns for global reset to finish
        #100;

        // Add stimulus here

    end

    always #5 clk = ~clk;
endmodule

