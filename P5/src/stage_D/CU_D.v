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
    output reg       a1_op,       // sllʱΪ1

    input [4:0] reg_addr_E,  //�����ͻ
    input [4:0] reg_addr_M,

    output reg [1:0] Tnew,
    output reg       stall
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

    //��������Tuse Tnew����
    wire cal_r = (add | sub | sll);
    wire cal_i = (ori | lui);
    wire load = lw;
    wire store = sw;

    //stall
    reg                                 [1:0] Tuse_rs;
    reg                                 [1:0] Tuse_rt;
    reg                                       stall_rs_E;
    reg                                       stall_rs_M;
    reg                                       stall_rt_E;
    reg                                       stall_rt_M;

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

        ///////////////////////// ð�մ���ģ�� //////////////////////////////////////

        /********* Tuse ************************/
        if (beq | jr) Tuse_rs = 2'd0;
        else if ((cal_r & ~sll) | cal_i | load | store) Tuse_rs = 2'd1;
        else Tuse_rs = 2'd3;  //Ĭ��д�ػ��� ��ȻsllΪcal_r������rs

        if (beq) Tuse_rt = 2'd0;
        else if (cal_r) Tuse_rt = 2'd1;
        else if (store) Tuse_rt = 2'd2;
        else Tuse_rt = 2'd3;  //Ĭ��д�ػ���

        /********* Tnew ************************/
        if (beq | jr) Tnew = 2'd0;  //��ʼ���� ������������
        else if (cal_r | cal_i) Tnew = 2'd1;
        else if (load | store | jal) Tnew = 2'd2;
        else Tnew = 2'd0;  //Ĭ�ϳ�ʼ���� ������������

        /********* stall ***********************/
        stall_rs_E = (Tuse_rs < Tnew_E) & (rs != 5'd0 & rs == reg_addr_E);  //������д��reg_addr=0
        stall_rs_M = (Tuse_rs < Tnew_M) & (rs != 5'd0 & rs == reg_addr_M);

        stall_rt_E = (Tuse_rt < Tnew_E) & (rt != 5'd0 & rt == reg_addr_E);
        stall_rt_M = (Tuse_rt < Tnew_M) & (rt != 5'd0 & rt == reg_addr_M);

        stall     = (stall_rs_E | stall_rs_M) | (stall_rt_E | stall_rt_M);
    end
endmodule
