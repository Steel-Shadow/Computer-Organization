`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:14:35 10/17/2022
// Design Name:   top_module
// Module Name:   D:/CO/P1/tb_top.v
// Project Name:  p1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_module
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_top;

    // Inputs
    reg        clk;
    reg  [7:0] in;
    reg        reset;

    // Outputs
    wire       done;

    // Instantiate the Unit Under Test (UUT)
    top_module uut (
        .clk  (clk),
        .in   (in),
        .reset(reset),
        .done (done)
    );

    initial begin
        // Initialize Inputs
        clk   = 1;
        reset = 1;
		in	  = 0;
        #9;
        reset = 0;
        #1;
        in[3] = 0;#10;

        in[3] = 0;#10;
        in[3] = 0;#10;
        in[3] = 1;#10;
        in[3] = 0;#10;
        in[3] = 0;#10;
        in[3] = 1;#10;
        in[3] = 0;#10;
        in[3] = 0;#10;
		
        in[3] = 1;#10;
    end
    always #5 clk = ~clk;
endmodule

