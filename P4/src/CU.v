`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:16:07 11/09/2022 
// Design Name: 
// Module Name:    CU 
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
module CU (
    input [31:0] instr,

    output [25:21] rs,
    output [20:16] rt,
    output [15:11] rd,
    output [ 10:6] shamt,
    output [ 15:0] imm,
    output [ 25:0] j_address,

    output reg [2:0] next_pc_op,  //PC部分

    output reg       reg_write,    // GRF部分
    output reg       a1_op,        // sll时为1
    output reg [1:0] reg_addr_op,  // rd-0 rt-1 $ra=31-2 
    output reg [2:0] reg_data_op,  // 

    output reg [2:0] alu_op,   // ALU部分
    output reg [2:0] alu_b_op,

    output reg mem_write  //DM部分
);
    wire [5:0] func;
    wire [5:0] op;
    /*********************splitter*******************/
    assign op        = instr[31:26];

    assign rs        = instr[25:21];

    assign rt        = instr[20:16];

    assign rd        = instr[15:11];

    assign shamt     = instr[10:6];

    assign func      = instr[5:0];

    assign imm       = instr[15:0];

    assign j_address = instr[25:0];

    //add, sub, ori, lw, sw, beq, lui, jal, jr, nop    添加sll lh slt
    reg add, sub, ori, lw, sw, beq, lui, jal, jr, sll, lh, slt, srav;  //op
    reg func_add, func_sub, func_jr, func_sll, func_slt, func_srav;  //func

    always @(*) begin
        func_add  = 1'b0;
        func_sub  = 1'b0;
        func_jr   = 1'b0;
        func_sll  = 1'b0;
        func_slt  = 1'b0;
        func_srav = 1'b0;
        case (func)
            6'b100000: func_add = 1'b1;
            6'b100010: func_sub = 1'b1;
            6'b001000: func_jr = 1'b1;
            6'b000000: func_sll = 1'b1;
            6'b101010: func_slt = 1'b1;
            6'b000111: func_srav = 1'b1;
            default:   ;
        endcase

        add  = 1'b0;
        sub  = 1'b0;
        jr   = 1'b0;
        sll  = 1'b0;
        ori  = 1'b0;
        lw   = 1'b0;
        sw   = 1'b0;
        beq  = 1'b0;
        lui  = 1'b0;
        jal  = 1'b0;
        lh   = 1'b0;
        slt  = 1'b0;
        srav = 1'b0;
        case (op)
            6'b000000: begin
                add  = func_add;
                sub  = func_sub;
                jr   = func_jr;
                sll  = func_sll;
                slt  = func_slt;
                srav = func_srav;
            end
            6'b001101: ori = 1'b1;
            6'b100011: lw = 1'b1;
            6'b101011: sw = 1'b1;
            6'b000100: beq = 1'b1;
            6'b001111: lui = 1'b1;
            6'b000011: jal = 1'b1;
            6'b100001: lh = 1'b1;
            default:   ;
        endcase

        /* next_pc_op
        reg_write a1_op reg_addr_op reg_data_op
        alu_op alu_b_op
        mem_write                                  */

        //PC部分
        if (beq) next_pc_op = 3'd1;
        else if (jal) next_pc_op = 3'd2;
        else if (jr) next_pc_op = 3'd3;
        else next_pc_op = 3'd0;

        reg_write = (add | sub | ori | lw | lui | jal | sll | lh | slt | srav);
        a1_op     = sll;

        //rd-0 rt-1 $ra=31-2 
        if (add | sub | sll | slt) reg_addr_op = 2'd0;  //rd
        else if (lw | lui | ori | lh) reg_addr_op = 2'd1;  //rt
        else if (jal) reg_addr_op = 2'd2;  //$ra $31
        else reg_addr_op = 2'd3;  //error

        //3位
        if (lw) reg_data_op = 3'd1;  //dm_out
        else if (lui) reg_data_op = 3'd2;  //imm<<16
        else if (jal) reg_data_op = 3'd3;  //pc+4
        else if (lh) reg_data_op = 3'd4;  //dm_out lh
        else if (slt) reg_data_op = 3'd5;  //slt
        else reg_data_op = 3'd0;  //alu_out

        // + - | compare(>1 ==0 <-1) 有符号比较 
        if (add | lw | lh) alu_op = 3'd0;
        else if (sub) alu_op = 3'd1;
        else if (ori) alu_op = 3'd2;
        else if (beq | slt) alu_op = 3'd3;
        else if (sll) alu_op = 3'd4;
        else if (srav) alu_op = 3'd5;  //算术右移 保留符号位 b>>a
        else alu_op = 3'd0;

        //3位
        if (lw | sw | lh) alu_b_op = 3'd1;  //sign_ext imm
        else if (ori) alu_b_op = 3'd2;  //zero_ext imm
        else if (sll) alu_b_op = 3'd3;  //zero_ext shamt
        else alu_b_op = 3'd0;  //GRF_RD2 read2

        if (sw) mem_write = 1'b1;
        else mem_write = 1'b0;

    end

endmodule
