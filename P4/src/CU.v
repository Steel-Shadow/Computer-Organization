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
    output [  5:0] func,
    output [ 15:0] imm,
    output [ 25:0] j_address,


    output reg       reg_write,    // GRF部分
    output reg       a1_op,        // sll时为1
    output reg [1:0] reg_addr_op,  // rd-0 rt-1 $ra=31-2 
    output reg [2:0] reg_data_op,  // 

    output reg [2:0] alu_op,   // ALU部分
    output reg [2:0] alu_b_op,

    output reg mem_write  //DM部分
);
    /*********************splitter*******************/
    assign op        = instr[31:26];

    assign rs        = instr[25:21];

    assign rt        = instr[20:16];

    assign rd        = instr[15:11];

    assign shamt     = instr[10:6];

    assign func      = instr[5:0];

    assign imm       = instr[15:0];

    assign j_address = instr[25:0];

    //add, sub, ori, lw, sw, beq, lui, jal, jr, nop    添加sll
    reg add, sub, ori, lw, sw, beq, lui, jal, jr, sll;  //op
    reg func_add, func_sub, func_jr, func_sll;  //func

    always @(*) begin
        func_add = 1'b0;
        func_sub = 1'b0;
        func_jr  = 1'b0;
        func_sll = 1'b0;
        case (func)
            6'b100000: func_add = 1'b1;
            6'b100010: func_sub = 1'b1;
            6'b001000: func_jr = 1'b1;
            6'b000000: func_sll = 1'b1;
            default:   ;
        endcase

        add = 1'b0;
        sub = 1'b0;
        jr  = 1'b0;
        sll = 1'b0;
        ori = 1'b0;
        lw  = 1'b0;
        sw  = 1'b0;
        beq = 1'b0;
        lui = 1'b0;
        jal = 1'b0;
        case (op)
            6'b000000: begin
                add = func_add;
                sub = func_sub;
                jr  = func_jr;
                sll = func_sll;
            end
            6'b001101: ori = 1'b1;
            6'b100011: lw = 1'b1;
            6'b101011: sw = 1'b1;
            6'b000100: beq = 1'b1;
            6'b001111: lui = 1'b1;
            6'b000011: jal = 1'b1;
            default:   ;
        endcase

        /*  reg_write a1_op reg_addr_op reg_data_op
        alu_op alu_b_op
        mem_write                                  */
        reg_write = (add | sub | ori | lw | lui | jal | sll);
        a1_op     = sll;

        //rd-0 rt-1 $ra=31-2 
        if (add | sub | ori | sll) reg_addr_op = 2'd0;  //rd
        else if (lw | lui) reg_addr_op = 2'd1;  //rt
        else if (jal) reg_addr_op = 2'd2;  //$ra $31
        else reg_addr_op = 2'd3;  //error

        //3位
        if (lw) reg_data_op = 3'd1;  //DM_out
        else if (lui) reg_data_op = 3'd2;  //imm<<16
        else if (jal) reg_data_op = 3'd3;  //pc+4
        else reg_data_op = 3'd0;  //ALU_out

        // + - | compare(>1 ==0 <-1) 有符号比较
        if (add | lw) alu_op = 3'd0;
        else if (sub) alu_op = 3'd1;
        else if (ori) alu_op = 3'd2;
        else if (beq) alu_op = 3'd3;
        else alu_op = 3'd7;

        //3位
        if (lw | sw) alu_b_op = 3'd1;  //sign_ext imm
        else if (ori) alu_b_op = 3'd2;  //zero_ext imm
        else if (sll) alu_b_op = 3'd3;  //zero_ext shamt
        else alu_b_op = 3'd0;  //GRF_RD2

        if (sw) mem_write = 1'b1;
        else mem_write = 1'b0;

    end

endmodule
