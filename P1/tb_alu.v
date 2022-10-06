`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:27:32 10/05/2022
// Design Name:   alu
// Module Name:   D:/CO/p1/tb_alu.v
// Project Name:  p1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_alu;

    // Inputs
    reg  [31:0] A;
    reg  [31:0] B;
    reg  [ 2:0] ALUOp;

    // Outputs
    wire [31:0] C;

    // Instantiate the Unit Under Test (UUT)
    alu uut (
        .A    (A),
        .B    (B),
        .ALUOp(ALUOp),
        .C    (C)
    );

    initial begin
        // Initialize Inputs
        A     = {{31{2'b0}}, 2'b1};
        B     = 0;
        ALUOp = 0;

        // Wait 100 ns for global reset to finish
        #100;

        // Add stimulus here

    end

endmodule

