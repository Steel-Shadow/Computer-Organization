module ALU (
    input  [31:0] a,
    input  [31:0] b,
    input  [ 2:0] alu_op,
    output [31:0] alu_out
);
    //+ - | compare(>1 ==0 <-1) ÓĞ·ûºÅ±È½Ï
    reg [31:0] ans;

    assign alu_out = ans;

    always @(*) begin
        case (alu_op)
            0: ans = a + b;
            1: ans = a - b;
            2: ans = a | b;
            3: ans = ($signed(a) > $signed(b) ? 1 : a == b ? 0 : -1);
            4: ans = a << b;
            default: ans = 0;
        endcase
    end
endmodule
