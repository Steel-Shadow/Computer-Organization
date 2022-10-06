`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:59:16 10/06/2022 
// Design Name: 
// Module Name:    new_alu 
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
module newalu (
    input      [31:0] A,
    input      [31:0] B,
    input      [ 2:0] ALUOp,
    output [31:0] C
);
	reg [31:0] newC;
	assign C=newC;
    always @(*) begin
        case (ALUOp)
            0: newC = A + B;
            1: newC = A - B;
            2: newC = A & B;
            3: newC = A | B;
            4: newC = A >> B;
            5: newC = $signed(A) >>> B;
            default: newC = 0;
        endcase
    end
endmodule

