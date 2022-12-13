module CU_D (
    input [31:0] instr,

    output [25:21] rs,
    output [20:16] rt,
    output [15:11] rd,
    output [ 10:6] shamt,
    output [ 15:0] imm,
    output [ 25:0] j_address,

    output reg [2:0] next_pc_op,  //PC
    output reg [2:0] ext_op,      //EXT

    input [4:0] reg_addr_E,  //处理冲突
    input [4:0] reg_addr_M,
    input [4:0] reg_addr_W,

    input      [1:0] Tnew_E,
    input      [1:0] Tnew_M,
    output reg [1:0] Tnew,

    input start,
    input busy,

    output reg stall,

    output reg [1:0] fwd_rs_data_D_op,
    output reg [1:0] fwd_rt_data_D_op,

    input lwm_E,
    input lwm_M
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

    //P6添加指令
    wire instr_and = R & (func == 6'b100100);
    wire instr_or = R & (func == 6'b100101);
    wire slt = R & (func == 6'b101010);
    wire sltu = R & (func == 6'b101011);

    wire addi = (op == 6'b001000);
    wire andi = (op == 6'b001100);
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

    //分组用于Tuse Tnew分析
    wire cal_r = (add | sub | sll | instr_and | instr_or | slt | sltu);
    wire cal_i = (ori | lui | addi | andi);
    wire load = (lw | lb | lh);
    wire store = (sw | sb | sh);
    wire md = (mult | multu | div | divu | bds);
    ;
    //stall
    reg [1:0] Tuse_rs;
    reg [1:0] Tuse_rt;
    reg       stall_rs_E;
    reg       stall_rs_M;
    reg       stall_rt_E;
    reg       stall_rt_M;

    always @(*) begin
        /********* PC *************************/
        if (beq) next_pc_op = 3'd1;
        else if (jal) next_pc_op = 3'd2;
        else if (jr) next_pc_op = 3'd3;
        else if (bne) next_pc_op = 3'd4;
        else if (btheq) next_pc_op = 3'd5;
        else next_pc_op = 3'd0;

        /********* EXT *************************/
        if (load | store | addi | lwm) ext_op = 3'd0;  //sign_ext imm
        else if (ori | lui | andi) ext_op = 3'd1;  //zero_ext imm
        else if (sll) ext_op = 3'd2;  //zero_ext shamt
        else ext_op = 3'd3;  //0 默认符号扩展imm

        ///////////////////////// 冒险处理模块 //////////////////////////////////////

        /********* Tuse ************************/
        if (beq | jr | bne | btheq) Tuse_rs = 2'd0;
        else if ((cal_r & ~sll) | cal_i | load | store | md | mthi | mtlo | lwm) Tuse_rs = 2'd1;
        else Tuse_rs = 2'd3;  //默认写回或不用 虽然sll为cal_r但不用rs

        if (beq | bne | btheq) Tuse_rt = 2'd0;
        else if (cal_r | md) Tuse_rt = 2'd1;
        else if (store) Tuse_rt = 2'd2;
        else Tuse_rt = 2'd3;  //默认写回或不用

        /********* Tnew ************************/
        if (beq | jr | jal | bne | btheq) Tnew = 2'd0;  //初始产生 不产生新数据
        else if (cal_r | cal_i | mfhi | mflo) Tnew = 2'd1;
        else if (load) Tnew = 2'd2;
        else if (lwm) Tnew = 2'd3;
        else Tnew = 2'd0;  //默认初始产生 不产生新数据

        /********* stall ***********************/
        stall_rs_E = (Tuse_rs < Tnew_E) & (rs != 5'd0 & rs == reg_addr_E);  //若不可写则reg_addr=0
        stall_rs_M = (Tuse_rs < Tnew_M) & (rs != 5'd0 & rs == reg_addr_M);

        stall_rt_E = (Tuse_rt < Tnew_E) & (rt != 5'd0 & rt == reg_addr_E);
        stall_rt_M = (Tuse_rt < Tnew_M) & (rt != 5'd0 & rt == reg_addr_M);

        stall      = (lwm_E | lwm_M) | (stall_rs_E | stall_rs_M) | (stall_rt_E | stall_rt_M) | ((busy | start) & (md | mfhi | mflo | mthi | mtlo));

        /********* forward ***********************/
        if (rs == reg_addr_E & rs != 5'd0 & Tnew_E == 2'b00) fwd_rs_data_D_op = 2'd3;
        else if (rs == reg_addr_M & rs != 5'd0 & Tnew_M == 2'b00) fwd_rs_data_D_op = 2'd2;
        else if (rs == reg_addr_W & rs != 5'd0) fwd_rs_data_D_op = 2'd1;
        else fwd_rs_data_D_op = 2'd0;

        if (rt == reg_addr_E & rt != 5'd0 & Tnew_E == 2'b00) fwd_rt_data_D_op = 2'd3;
        else if (rt == reg_addr_M & rt != 5'd0 & Tnew_M == 2'b00) fwd_rt_data_D_op = 2'd2;
        else if (rt == reg_addr_W & rt != 5'd0) fwd_rt_data_D_op = 2'd1;
        else fwd_rt_data_D_op = 2'd0;

    end
endmodule
