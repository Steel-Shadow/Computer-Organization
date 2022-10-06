`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:58:22 09/29/2022
// Design Name:   homework
// Module Name:   D:/CO/ISE/Pre/tb_homework.v
// Project Name:  Pre
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: homework
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_homework;

	// Inputs
	reg A1;
	reg A2;
	reg A3;

	// Outputs
	wire Y;

	// Instantiate the Unit Under Test (UUT)
	homework uut (
		.A1(A1), 
		.A2(A2), 
		.A3(A3), 
		.Y(Y)
	);

	initial begin
		// Initialize Inputs
		A1 = 1;
		A2 = 1;
		A3 = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

