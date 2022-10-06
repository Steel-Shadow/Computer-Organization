`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:43:32 10/06/2022
// Design Name:   BlockChecker
// Module Name:   D:/CO/p1/tb_BlockChecker.v
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
    reg  [63:0] word;
    // Outputs 
    wire        result;

    // Instantiate the Unit Under Test (UUT)
    BlockChecker uut (
        .clk   (clk),
        .reset (reset),
        .in    (in),
        .result(result),
        .word  (word)
    );

   
endmodule

