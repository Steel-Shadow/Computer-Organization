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

    output reg a1_op  // sllʱΪ1
);
    assign op        = instr[31:26];
    assign rs        = instr[25:21];
    assign rt        = instr[20:16];
    assign rd        = instr[15:11];
    assign shamt     = instr[10:6];
    assign func      = instr[5:0];
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

    always @(*) begin
        //next_pc_op
        if (beq) next_pc_op = 3'd1;
        else if (jal) next_pc_op = 3'd2;
        else if (jr) next_pc_op = 3'd3;
        else next_pc_op = 3'd0;

        /******** GRF **********************/
        a1_op = sll;

        /********* EXT *************************/
        //ext_op
        if (lw | sw) ext_op = 3'd0;  //sign_ext imm
        else if (ori) ext_op = 3'd1;  //zero_ext imm
        else if (sll) ext_op = 3'd2;  //zero_ext shamt
        else ext_op = 3'd3;  //z

    end
endmodule
