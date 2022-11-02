`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:03:51 11/02/2022 
// Design Name: 
// Module Name:    test 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module test(
output 	reg [31:0] a,
output 	reg [31:0] b,
output 	reg [31:0] c
    );
initial begin
	a=1;
	b=0;
	c=1;
end
// a=1 b=1 c=1
initial begin
	#1;
	a<=b;
	b=c;
	c<=b;
end

endmodule
