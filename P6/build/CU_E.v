module CU_E (
    input [31:0] instr,

    output [25:21] rs,
    output [20:16] rt,
    output [15:11] rd,
    output [ 10:6] shamt,
    output [ 15:0] imm,
    output [ 25:0] j_address,

    output reg [3:0] alu_op,  //alu
    output reg [3:0] md_op,   //md

    output reg [4:0] reg_addr,  //冲突处理

    input [4:0] reg_addr_M,
    input [4:0] reg_addr_W,
    input [1:0] Tnew_M,

    output reg [1:0] fwd_rs_data_E_op,
    output reg [1:0] fwd_rt_data_E_op
);
    wire [5:0] op = instr[31:26];
    assign rs    = instr[25:21];
    assign rt    = instr[20:16];
    assign rd    = instr[15:11];
    assign shamt = instr[10:6];
    wire [5:0] func = instr[5:0];
    assign imm       = instr[15:0];
    assign j_address = instr[25:0];

    wire R = (op == 6'b000000);

    wire add = R & (func == 6'b100000);
    wire sub = R & (func == 6'b100010);
    wire jr = R & (func == 6'b001000);
    wire sll = R & (func == 6'b000000);

    wire ori = (op == 6'b001101);
    wire lw = (op == 6'b100011);
    wire sw = (op == 6'b101011);
    wire beq = (op == 6'b000100);
    wire lui = (op == 6'b001111);
    wire jal = (op == 6'b000011);

    //P6额外添加指令
    wire instr_and = R & (func == 6'b100100);
    wire instr_or = R & (func == 6'b100101);
    wire slt = R & (func == 6'b101010);
    wire sltu = R & (func == 6'b101011);

    wire andi = (op == 6'b001100);
    wire addi = (op == 6'b001000);
    wire lb = (op == 6'b100000);
    wire lh = (op == 6'b100001);
    wire sb = (op == 6'b101000);
    wire sh = (op == 6'b101001);

    wire bne = (op == 6'b000101);

    wire mult = R & (func == 6'b011000);
    wire multu = R & (func == 6'b011001);
    wire div = R & (func == 6'b011010);
    wire divu = R & (func == 6'b011011);

    wire mfhi = R & (func == 6'b010000);
    wire mflo = R & (func == 6'b010010);
    wire mthi = R & (func == 6'b010001);
    wire mtlo = R & (func == 6'b010011);

    //分类
    wire cal_r = (add | sub | sll | instr_and | instr_or | slt | sltu);
    wire cal_i = (ori | lui | addi | andi);
    wire load = (lw | lb | lh);
    wire store = (sw | sb | sh);
    wire md = (mult | multu | div | divu);

    always @(*) begin
        //alu_op
        if (add) alu_op = 4'd0;
        else if (sub) alu_op = 4'd1;
        else if (ori) alu_op = 4'd2;
        else if (load | store) alu_op = 4'd3;
        else if (lui) alu_op = 4'd4;
        else if (sll) alu_op = 4'd5;
        else if (addi) alu_op = 4'd6;
        else if (instr_and) alu_op = 4'd7;
        else if (instr_or) alu_op = 4'd8;
        else if (slt) alu_op = 4'd9;
        else if (sltu) alu_op = 4'd10;
        else if (andi) alu_op = 4'd11;
        else alu_op = 4'd0;

        //md_op
        if (mult) md_op = 4'd1;
        else if (multu) md_op = 4'd2;
        else if (div) md_op = 4'd3;
        else if (divu) md_op = 4'd4;
        else if (mfhi) md_op = 4'd5;
        else if (mflo) md_op = 4'd6;
        else if (mthi) md_op = 4'd7;
        else if (mtlo) md_op = 4'd8;
        else md_op = 4'd0;

        //reg_addr 
        if (cal_r | mfhi | mflo) reg_addr = rd;  //rd
        else if (load | cal_i) reg_addr = rt;  //rt
        else if (jal) reg_addr = 5'd31;  //$ra $31
        else reg_addr = 5'd0;  //$0

        /********* forward ***********************/
        if (rs == reg_addr_M & rs != 5'd0 & Tnew_M == 2'b00) fwd_rs_data_E_op = 2'd2;
        else if (rs == reg_addr_W & rs != 5'd0) fwd_rs_data_E_op = 2'd1;
        else fwd_rs_data_E_op = 2'd0;

        if (rt == reg_addr_M & rt != 5'd0 & Tnew_M == 2'b00) fwd_rt_data_E_op = 2'd2;
        else if (rt == reg_addr_W & rt != 5'd0) fwd_rt_data_E_op = 2'd1;
        else fwd_rt_data_E_op = 2'd0;
    end
endmodule
