module CU_D (
    input [31:0] instr,

    output [25:21] rs,
    output [20:16] rt,
    output [15:11] rd,
    output [ 10:6] shamt,
    output [ 15:0] imm,
    output [ 25:0] j_address,

    output reg [2:0] next_pc_op,  //PC

    output reg [2:0] ext_op,  //EXT

    output reg a1_op,  // sll时为1

    output reg [1:0] Tuse_rs,
    output reg [1:0] Tuse_rt,
    output reg [1:0] Tnew
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

    wire ori = op == 6'b001101;
    wire lw = op == 6'b100011;
    wire sw = op == 6'b101011;
    wire beq = op == 6'b000100;
    wire lui = op == 6'b001111;
    wire jal = op == 6'b000011;

    wire cal_r = (add | sub | sll);
    wire cal_i = (ori | lui);
    wire load = lw;
    wire store = sw;

    always @(*) begin
        /********* PC *************************/
        if (beq) next_pc_op = 3'd1;
        else if (jal) next_pc_op = 3'd2;
        else if (jr) next_pc_op = 3'd3;
        else next_pc_op = 3'd0;

        /********* GRF *************************/
        a1_op = sll;

        /********* EXT *************************/
        if (lw | sw) ext_op = 3'd0;  //sign_ext imm
        else if (ori) ext_op = 3'd1;  //zero_ext imm
        else if (sll) ext_op = 3'd2;  //zero_ext shamt
        else ext_op = 3'd3;  //z

        /********* Tuse ************************/
        if (beq | jr) Tuse_rs = 2'd0;
        else if ((cal_r & ~sll) | cal_i | load | store) Tuse_rs = 2'd1;
        else Tuse_rs = 2'd3;  //默认写回或不用 虽然sll为cal_r但不用rs

        if (beq) Tuse_rt = 2'd0;
        else if (cal_r) Tuse_rt = 2'd1;
        else if (store) Tuse_rt = 2'd2;
        else Tuse_rt = 2'd3;  //默认写回或不用

        /********* Tnew ************************/
        if (beq | jr) Tnew = 2'd0;  //初始产生 不产生新数据
        else if (cal_r | cal_i) Tnew = 2'd1;
        else if (load | store | jal) Tnew = 2'd2;
        else Tnew = 2'd0;  //默认初始产生 不产生新数据
    end
endmodule
