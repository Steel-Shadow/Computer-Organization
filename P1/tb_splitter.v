`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:00:09 10/05/2022
// Design Name:   splitter
// Module Name:   D:/CO/p1/tb_splitter.v
// Project Name:  p1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: splitter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_splitter;

    // Inputs
    reg  [31:0] A;

    // Outputs
    wire [ 7:0] O1;
    wire [ 7:0] O2;
    wire [ 7:0] O3;
    wire [ 7:0] O4;

    // Instantiate the Unit Under Test (UUT)
    splitter uut (
        .A (A),
        .O1(O1),
        .O2(O2),
        .O3(O3),
        .O4(O4)
    );

    initial begin
        // Initialize Inputs
        A = 32'b00100001000000110000000000000000;

        // Wait 100 ns for global reset to finish
        #100;
        $display("%d%d%d%d", O1, O2, O3, O4);
        $display("%d", $signed(2'b01) > $signed(2'b11));
        // Add stimulus here

    end

endmodule

