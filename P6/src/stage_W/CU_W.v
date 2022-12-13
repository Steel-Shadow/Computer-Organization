module CU_W (
    input [31:0] instr,

    output [25:21] rs,
    output [20:16] rt,
    output [15:11] rd,
    output [ 10:6] shamt,
    output [ 15:0] imm,
    output [ 25:0] j_address,

    output reg [4:0] reg_addr,

    output reg [2:0] give_W_op,

    input [31:0] dm_lwm,
    input [31:0] rt_data
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

    wire bds = R & (func == 6'b001010);

    wire lwm = (op == 6'b101100);

    wire btheq = (op == 6'b101111);

    wire cal_r = (add | sub | sll | instr_and | instr_or | slt | sltu);
    wire cal_i = (ori | lui | addi | andi);
    wire load = (lw | lb | lh);
    wire store = (sw | sb | sh);
    wire md = (mult | multu | div | divu | bds);

    always @(*) begin
        //reg_addr
        if (cal_r | mfhi | mflo) reg_addr = rd;  //rd
        else if (load | cal_i) reg_addr = rt;  //rt
        else if (jal) reg_addr = 5'd31;  //$ra $31
        else if (lwm) begin
            reg_addr = dm_lwm - rt_data;
        end else reg_addr = 5'd0;  //$0

        //give_W_op 兼顾转发与reg_data
        if (jal) give_W_op = 3'd0;  //pc_W+8
        else if (cal_r | cal_i) give_W_op = 3'd1;  //alu_out_W
        else if (mfhi | mflo) give_W_op = 3'd2;  //md_out_W
        else if (load | lwm) give_W_op = 3'd3;  //dm_out_W
        else give_W_op = 3'd0;  //else
    end
endmodule
