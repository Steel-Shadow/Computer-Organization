module CU_M (
    input [31:0] instr,

    output [25:21] rs,
    output [20:16] rt,
    output [15:11] rd,
    output [ 10:6] shamt,
    output [ 15:0] imm,
    output [ 25:0] j_address,

    output reg mem_write,

    output reg [4:0] reg_addr,  //判断冒险

    output reg give_M_op,

    input      [4:0] reg_addr_W,
    output reg       fwd_rt_data_M_op
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

    wire cal_r = (add | sub | sll);
    wire cal_i = (ori | lui | addi);
    wire load = lw;
    wire store = sw;

    always @(*) begin
        mem_write = (sw);

        if (jal) give_M_op = 1'd0;
        else give_M_op = 1'd1;

        //reg_addr 
        if (cal_r) reg_addr = rd;  //rd
        else if (load | cal_i) reg_addr = rt;  //rt
        else if (jal) reg_addr = 5'd31;  //$ra $31
        else reg_addr = 5'd0;  //$0

        /********* forward ***********************/
        if (rt == reg_addr_W & rt != 5'd0) fwd_rt_data_M_op = 1'd1;
        else fwd_rt_data_M_op = 1'd0;
    end
endmodule
