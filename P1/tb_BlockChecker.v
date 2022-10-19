`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:02:06 10/06/2022
// Design Name:   BlockChecker
// Module Name:   D:/CO/p1/tb_bc.v
// Project Name:  p1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: BlockChecker
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_BlockChecker;

    // Inputs
    reg         clk;
    reg         reset;
    reg  [ 7:0] in;

    // Outputs
    wire        result;

    // Instantiate the Unit Under Test (UUT)
    BlockChecker uut (
        .clk   (clk),
        .reset (reset),
        .in    (in),
        .result(result)
    );

    initial begin
        // Initialize Inputs
        clk   = 0;
        reset = 1;
        in    = 0;

        #1;
        reset = 0;
        // Add stimulus here
        #4;
        in = "h";
        #10;
        in = "i";
        #10;
        in = " ";
        #10;
        in = "b";
        #10;
        in = "e";
        #10;
        in = "g";
        #10;
        in = "i";
        #10;
        in = "n";
        #10;
        in = "a";
    end

    always #5 clk = ~clk;
endmodule

