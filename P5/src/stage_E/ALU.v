module ALU (
    input  [31:0] a,
    input  [31:0] b,
    input  [ 2:0] alu_op,
    output [31:0] alu_out
);
    //+ - | compare(>1 ==0 <-1) ÓÐ·ûºÅ±È½Ï
    reg [31:0] ans;

    assign alu_out = ans;

    always @(*) begin
        case (alu_op)
            0: ans = a + b;
            1: ans = a - b;
            2: ans = a | b;
            3: ans = a << b;
            4: ans = ($signed(a) > $signed(b) ? 1 : a == b ? 0 : -1);
            default: ans = 0;
        endcase
    end
endmodule
