`timescale 1ns / 1ps

module tb_mips;


    // mips Inputs
    reg clk = 1;
    reg reset = 1;

    // mips Outputs

    always #5 clk = ~clk;

    initial begin
        #4 reset = 0;
    end

    mips u_mips (
        .clk  (clk),
        .reset(reset)
    );

endmodule
