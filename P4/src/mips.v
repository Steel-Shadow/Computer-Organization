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
    //PC 
    wire [31:0] pc;

    PC u_PC (
        .clk  (clk),
        .reset(reset),

        .pc_out(pc)
    );

    //IM 
    wire [31:0] instr;

    IM u_IM (
        .pc(pc),

        .instr(instr)
    );

    // CU 
    wire [25:21] rs;
    wire [20:16] rt;
    wire [15:11] rd;
    wire [ 10:6] shamt;
    wire [  5:0] func;
    wire [ 15:0] imm;
    wire [ 25:0] j_address;
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
        .func       (func),
        .imm        (imm),
        .j_address  (j_address),
        .reg_write  (reg_write),
        .a1_op      (a1_op),
        .reg_addr_op(reg_addr_op),
        .reg_data_op(reg_data_op),
        .alu_op     (alu_op),
        .alu_b_op   (alu_b_op),
        .mem_write  (mem_write)
    );

    // MUX_4 GRF的reg_addr选择
    wire [4:0] reg_addr;

    MUX_4 #(
        .DATA_WIDTH(5)
    ) u_MUX_4_GRF_reg_addr (
        .sel  (reg_addr_op),
        .data0(rd),
        .data1(rt),
        .data2(5'd31),

        .ans(reg_addr)
    );

    // MUX_8 GRF的reg_data选择        
    wire [31:0] reg_data;

    MUX_8 #(
        .DATA_WIDTH(32)
    ) u_MUX_8_GRF_reg_data (
        .sel  (reg_data_op),
        .data0(ALU_out),
        .data1(DM_out),
        .data2({imm, {16{0}}}),
        .data3(pc + 4),

        .ans(reg_data)
    );

    // GRF Outputs      
    wire [31:0] read1;
    wire [31:0] read2;

    GRF u_GRF (
        .reset    (reset),
        .clk      (clk),
        .pc       (pc),
        .reg_write(reg_write),
        .a1       (a1_op ? rt : rd),  //sll时选择rt
        .a2       (rt),               //rt
        .reg_addr (reg_addr),
        .reg_data (reg_data),

        .read1(read1),
        .read2(read2)
    );

    // ALU Inputs      
    reg  [31:0] a;
    reg  [31:0] b;

    // ALU Outputs
    wire [31:0] alu_out;

    ALU u_ALU (
        .a     (a),
        .b     (b),
        .alu_op(alu_op),

        .alu_out(alu_out)
    );
endmodule
