`define s0 3'b000
`define s1 3'b001
`define s2 3'b011
`define s3 3'b010
`define s4 3'b110
`define s5 3'b111
`define s6 3'b101
`define s7 3'b100

module gray (
    input            Clk,
    input            Reset,
    input            En,
    output reg [2:0] Output,
    output reg       Overflow
);
    always @(posedge Clk) begin
        if (Reset) begin
            Output   <= 0;
            Overflow <= 0;
        end else begin
            if (En) begin
                case (Output)

                    `s0: Output <= `s1;
                    `s1: Output <= `s2;
                    `s2: Output <= `s3;
                    `s3: Output <= `s4;
                    `s4: Output <= `s5;
                    `s5: Output <= `s6;
                    `s6: Output <= `s7;
                    `s7: begin
                        Output   <= `s0;
                        Overflow <= 1;
                    end
                    default: ;
                endcase
            end else;
        end
    end
endmodule
