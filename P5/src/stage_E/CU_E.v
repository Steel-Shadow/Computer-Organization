module CU_E (
    input [31:0] instr,

    output [25:21] rs,
    output [20:16] rt,
    output [15:11] rd,
    output [ 10:6] shamt,
    output [ 15:0] imm,
    output [ 25:0] j_address,

    output reg [3:0] alu_op,    //alu

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

    always @(*) begin
        // + - |
        if (add) alu_op = 4'd0;
        else if (sub) alu_op = 4'd1;
        else if (ori) alu_op = 4'd2;
        else if (lw | sw) alu_op = 4'd3;
        else if (lui) alu_op = 4'd4;
        else if (sll) alu_op = 4'd5;
        else alu_op = 4'd0;

        //reg_addr 
        if (add | sub | sll) reg_addr = rd;  //rd
        else if (lw | lui | ori) reg_addr = rt;  //rt
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
