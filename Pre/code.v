`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:02:54 09/08/2022 
// Design Name: 
// Module Name:    code 
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
module code (
    input             Clk,
    input             Reset,
    input             Slt,
    input             En,
    output reg [63:0] Output0,
    output reg [63:0] Output1
);

    reg [1:0] time1;

    always @(posedge Clk) begin
        if (Reset) begin
            Output0 <= 0;
            Output1 <= 0;
            time1   <= 0;
        end else if (En) begin
            if (Slt == 0) begin
                Output0 <= Output0 + 1;
                Output1 <= Output1;
                time1   <= time1;
            end else begin
                if (time1 == 3) begin
                    Output0 <= Output0;
                    Output1 <= Output1 + 1;
                    time1   <= 0;
                end else begin
                    Output0 <= Output0;
                    Output1 <= Output1;
                    time1   <= time1 + 2'b01;
                end
            end
        end else begin
            Output0 <= Output0;
            Output1 <= Output1;
            time1   <= time1;
        end
    end

endmodule
