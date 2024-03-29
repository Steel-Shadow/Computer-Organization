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

    output reg stall,

    output reg [1:0] fwd_rs_data_D_op,
    output reg [1:0] fwd_rt_data_D_op,

    input lwie_E,
    input lwie_M
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

    //额外添加指令
    wire addi = (op == 6'b001000);
    wire lwie = (op == 6'b111001);
    wire addei = (op == 6'b110011);
    wire bioal = (op == 6'b101101);

    //分组用于Tuse Tnew分析
    wire cal_r = (add | sub | sll);
    wire cal_i = (ori | lui | addi | addei);
    wire load = (lw | lwie);
    wire store = sw;
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
        else if (bioal) next_pc_op = 3'd4;
        else next_pc_op = 3'd0;

        /********* EXT *************************/
        if (load | sw | addi) ext_op = 3'd0;  //sign_ext imm
        else if (ori | lui) ext_op = 3'd1;  //zero_ext imm
        else if (sll) ext_op = 3'd2;  //zero_ext shamt
        else if (addei) ext_op = 3'd3;  //one_ext imm
        else ext_op = 3'd3;  //0 默认符号扩展imm

        ///////////////////////// 冒险处理模块 //////////////////////////////////////

        /********* Tuse ************************/
        if (beq | jr | bioal) Tuse_rs = 2'd0;
        else if ((cal_r & ~sll) | cal_i | load | store) Tuse_rs = 2'd1;
        else Tuse_rs = 2'd3;  //默认写回或不用 虽然sll为cal_r但不用rs

        if (beq | bioal) Tuse_rt = 2'd0;
        else if (cal_r) Tuse_rt = 2'd1;
        else if (store) Tuse_rt = 2'd2;
        else if (lwtbi) Tuse_rt = 2'd3;
        else Tuse_rt = 2'd3;  //默认写回或不用

        /********* Tnew ************************/
        if (beq | jr | jal | bioal) Tnew = 2'd0;  //初始产生 不产生新数据
        else if (cal_r | cal_i) Tnew = 2'd1;
        else if (load | lwtbi) Tnew = 2'd2;
        else Tnew = 2'd0;  //默认初始产生 不产生新数据

        /********* stall ***********************/
        stall_rs_E = (Tuse_rs < Tnew_E) & (rs != 5'd0 & rs == reg_addr_E);  //若不可写则reg_addr=0
        stall_rs_M = (Tuse_rs < Tnew_M) & (rs != 5'd0 & rs == reg_addr_M);

        stall_rt_E = (Tuse_rt < Tnew_E) & (rt != 5'd0 & rt == reg_addr_E);
        stall_rt_M = (Tuse_rt < Tnew_M) & (rt != 5'd0 & rt == reg_addr_M);

        stall      = (stall_rs_E | stall_rs_M) | (stall_rt_E | stall_rt_M) | (lwie_E | lwie_M);

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
