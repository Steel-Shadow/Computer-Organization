`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:20:25 10/06/2022
// Design Name:   expr
// Module Name:   D:/CO/p1/tb_expr.v
// Project Name:  p1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: expr
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_expr;

    // Inputs
    reg        clk;
    reg        clr;
    reg  [7:0] in;
    // Outputs
    wire       out;
    wire [2:0] s;
    // Instantiate the Unit Under Test (UUT)
    expr uut (
        .clk(clk),
        .clr(clr),
        .in (in),
        .out(out),
        .s  (s)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        in = "1";
        #10 in = "+";
        #10 in = "3";
        #10 in = "*";
        #10 in = "*";
        #10 in = "0";
        #10 clr = 1;
        #10 clr = 0;
        #10 in = "1";


    end

    always #5 clk = ~clk;
endmodule

