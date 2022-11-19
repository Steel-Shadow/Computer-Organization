`timescale 1ns / 1ps

module tb_mips;

    // mips Parameters     
    parameter PERIOD = 10;

    // mips Inputs
    reg clk = 1;
    reg reset = 1;

    // mips Outputs

    initial begin
        forever #(PERIOD / 2) clk = ~clk;
    end

    initial begin
        #(PERIOD * 0.4) reset = 0;
    end

    mips u_mips (
        .clk  (clk),
        .reset(reset)
    );

endmodule
