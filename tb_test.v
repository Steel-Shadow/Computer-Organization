`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:34:42 10/09/2022
// Design Name:   test
// Module Name:   D:/CO/P1/tb_test.v
// Project Name:  p1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: test
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_test;

	// Inputs
	reg [31:0] np;
	reg [7:0] vip;
	reg vvip;
	reg clk;

	// Outputs
	wire res;

	// Instantiate the Unit Under Test (UUT)
	test uut (
		.np(np), 
		.vip(vip), 
		.vvip(vvip), 
		.clk(clk), 
		.res(res)
	);

	initial begin
	
		clk=1;
		// Initialize Inputs
		np = 25;
		vip = 2;
		vvip = 1;
		
		// Wait 100 ns for global reset to finish
		#10;
      np = 5;
		vip = 4;
		vvip = 0;
		  
		// Add stimulus here

	end
	
	always
     #5 clk=~clk;
endmodule

