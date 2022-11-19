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
            3'd0: ans = a + b;
            3'd1: ans = a - b;
            3'd2: ans = a | b;
            3'd3: ans = a << b;
            3'd4: ans = b << 5'd16;
            // 4: ans = ($signed(a) > $signed(b) ? 1 : a == b ? 0 : -1);
            default: ans = 0;
        endcase
    end
endmodule
