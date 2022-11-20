module CU_E (
    input [31:0] instr,

    output [25:21] rs,
    output [20:16] rt,
    output [15:11] rd,
    output [ 10:6] shamt,
    output [ 15:0] imm,
    output [ 25:0] j_address,

    output reg       alu_b_op,  //alu²¿·Ö
    output reg [2:0] alu_op,

    output reg [4:0] reg_addr  //ÅÐ¶ÏÃ°ÏÕ
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
        alu_b_op = (ori | lw | sw | sll);  // 0/1 Ñ¡Ôñ read2 / ext

        // + - | compare(>1 ==0 <-1) ÓÐ·ûºÅ±È½Ï 
        if (add | lw) alu_op = 3'd0;
        else if (sub) alu_op = 3'd1;
        else if (ori) alu_op = 3'd2;
        else if (sll) alu_op = 3'd3;
        else if (lui) alu_op = 3'd4;  //lui b<<16
        else alu_op = 3'd0;

        //reg_addr ÅÐ¶ÏÃ°ÏÕ
        if (add | sub | sll) reg_addr = rd;  //rd
        else if (lw | lui | ori) reg_addr = rt;  //rt
        else if (jal) reg_addr = 5'd31;  //$ra $31
        else reg_addr = 5'd0;  //$0
    end
endmodule
