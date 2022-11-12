`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:50:44 11/09/2022 
// Design Name: 
// Module Name:    mips 
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
module mips (
    input clk,
    input reset
);
    wire [ 31:0] instr;

    wire [25:21] rs;
    wire [20:16] rt;
    wire [15:11] rd;
    wire [ 10:6] shamt;
    wire [  5:0] func;
    wire [ 15:0] imm;
    wire [ 25:0] j_address;
    wire [  2:0] next_pc_op;
    wire         reg_write;
    wire         a1_op;
    wire [  1:0] reg_addr_op;
    wire [  2:0] reg_data_op;
    wire [  2:0] alu_op;
    wire [  2:0] alu_b_op;
    wire         mem_write;

    CU u_CU (
        .instr(instr),

        .rs         (rs),
        .rt         (rt),
        .rd         (rd),
        .shamt      (shamt),
        .imm        (imm),
        .j_address  (j_address),
        .next_pc_op (next_pc_op),
        .reg_write  (reg_write),
        .a1_op      (a1_op),
        .reg_addr_op(reg_addr_op),
        .reg_data_op(reg_data_op),
        .alu_op     (alu_op),
        .alu_b_op   (alu_b_op),
        .mem_write  (mem_write)
    );

    DATAPATH u_DATAPATH (
        .clk        (clk),
        .reset      (reset),
        .rs         (rs),
        .rt         (rt),
        .rd         (rd),
        .shamt      (shamt),
        .imm        (imm),
        .j_address  (j_address),
        .next_pc_op (next_pc_op),
        .reg_write  (reg_write),
        .a1_op      (a1_op),
        .reg_addr_op(reg_addr_op),
        .reg_data_op(reg_data_op),
        .alu_op     (alu_op),
        .alu_b_op   (alu_b_op),
        .mem_write  (mem_write),

        .instr(instr)
    );
endmodule
