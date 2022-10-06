`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:19:29 09/11/2022 
// Design Name: 
// Module Name:    id_fsm 
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
module id_fsm (
    input  [7:0] char,
    input        clk,
    output       out
);
    `define s0 2'd0
    `define s1 2'd1
    `define s2 2'd2

    reg [1:0] state;

    always @(posedge clk) begin
        case (state)
            `s0: begin
                if (char >= 97 && char <= 122) begin
                    state <= `s1;
                end else begin
                    state <= `s0;
                end
            end // 48 57 97 122
            `s1: begin
                if (char >= 48 && char <= 57) begin
                    state <= `s2;
                end else if (char >= 97 && char <= 122) begin
                    state <= `s1;
                end else begin
                    state <= `s0;
                end
            end
            `s2: begin
                if (char >= 48 && char <= 57) begin
                    state <= `s2;
                end else if (char >= 97 && char <= 122) begin
                    state <= `s1;
                end else begin
                    state <= `s0;
                end
            end
            default: begin
                state <= `s0;
            end
        endcase
    end
    assign out = (state == `s2) ? 1'b1 : 1'b0;
endmodule
