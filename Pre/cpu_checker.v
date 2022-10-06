`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:36:52 09/11/2022 
// Design Name: 
// Module Name:    cpu_checker 
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
module cpu_checker (
    input            clk,
    input            reset,
    input      [7:0] char,
    output reg [1:0] format_type
);

    reg  [2:0] nDec;
    reg  [3:0] nHex;
    reg  [3:0] state;  //15
    wire [1:0] charType;
    reg        format;  //0 reg   1mem

    assign charType = (char >= "0" && char <= "9") ? 0 : (char >= "a" && char <= "f") ? 1 : 2;
    //num-0 abcdef-1 else-2

    always @(*) begin
        if (state == 13) begin
            if (format == 0) begin
                format_type = 1;
            end else begin
                format_type = 2;
            end
        end else format_type = 0;
    end

    always @(posedge clk) begin
        if (reset) begin
            format_type <= 0;
            nDec        <= 0;
            nHex        <= 0;
            state       <= 0;
        end else begin
            case (state)
                0: begin
                    if (char == "^") state <= 1;
                    else state <= 0;
                end
                1: begin  //0 in the MSB?
                    if (charType == 0) begin
                        state <= 2;
                        nDec  <= 1;
                    end else if (char == "^") begin
                        ;
                    end else begin
                        state <= 0;
                    end
                end
                2: begin
                    if (charType == 0 && nDec <= 3) begin
                        nDec = nDec + 1;
                    end else if (char == "@") begin
                        nDec  <= 0;
                        state <= 3;
                    end else if (char == "^") begin
                        nDec  <= 0;
                        state <= 1;
                    end else begin
                        nDec  <= 0;
                        state <= 0;
                    end
                end
                3: begin
                    if (charType <= 1) begin
                        nHex  <= 1;
                        state <= 4;
                    end else if (char == "^") state <= 1;
                    else begin
                        state <= 0;
                    end
                end
                4: begin
                    if (charType <= 1 && nHex <= 7) begin
                        nDec = nDec + 1;
                    end else if (char == ":" && nHex == 8) begin
                        state <= 5;
                        nHex  <= 0;
                    end else if (char == "^") begin
                        nHex  <= 0;
                        state <= 1;
                    end else begin
                        nHex  <= 0;
                        state <= 0;
                    end
                end
                5: begin
                    if (char == " ");
                    else if (char == "$") state <= 6;
                    else if (char == "*") state <= 7;
                    else if (char == "^") state <= 1;
                    else state <= 0;
                end
                6: begin
                    if (charType == 0) begin
                        nDec = 1;
                        state <= 8;
                    end else if (char == "^") state <= 1;
                    else state <= 0;
                end
                7: begin
                    if (charType <= 1) begin
                        nHex = 1;
                        state <= 9;
                    end else if (char == "^") state <= 1;
                    else state <= 0;
                end
                8: begin
                    if (charType == 0 && nDec <= 3) nDec = nDec + 1;
                    else if (char == " ") begin
                        nDec <= 4;
                    end else if (char == "^") begin
                        nDec  <= 0;
                        state <= 1;
                    end else if (char == "<" && nDec <= 4) begin
                        state  <= 10;
                        format <= 0;
                        nDec   <= 0;
                    end else begin
                        state <= 0;
                        nDec  <= 0;
                    end
                end
                9: begin
                    if (charType <= 1 && nHex <= 7) nHex = nHex + 1;
                    else if (char == " " && nHex == 8) begin
                        ;
                    end else if (char == "<" && nHex == 8) begin
                        state  <= 10;
                        format <= 1;
                        nHex   <= 0;
                    end else if (char == "^") begin
                        state <= 1;
                        nHex  <= 0;
                    end else begin
                        state <= 0;
                        nHex  <= 0;
                    end
                end
                10: begin
                    if (char == "=") state <= 11;
                    else if (char == "^") state <= 1;
                    else state <= 0;
                end
                11: begin
                    if (char == " ") begin
                        ;
                    end else if (charType <= 1) begin
                        nHex  <= 1;
                        state <= 12;
                    end else if (char == "^") state <= 1;
                    else state <= 0;
                end
                12: begin
                    if (charType <= 1 && nHex <= 7) nHex <= nHex + 1;
                    else if (nHex == 8 && char == "#") begin
                        state <= 13;
                        nHex  <= 0;
                    end else if (char == "^") begin
                        state <= 1;
                        nHex  <= 0;
                    end else begin
                        state <= 0;
                        nHex  <= 0;
                    end
                end
                13: begin
                    if (char == "^") state <= 1;
                    else state <= 0;
                end
                default: state <= 0;
            endcase
        end
    end
endmodule
