module ALU (
    input  [31:0] a,
    input  [31:0] b,
    input  [15:0] imm,
    input  [ 3:0] alu_op,
    output [31:0] alu_out
);
    //+ - | compare(>1 ==0 <-1) ÓÐ·ûºÅ±È½Ï
    reg [31:0] ans;
    reg [31:0] cnt;

    assign alu_out = ans;

    integer i;
    always @(*) begin
        case (alu_op)
            4'd0: ans = a + b;
            4'd1: ans = a - b;
            4'd2: ans = a | b;
            4'd3: ans = ($signed(a) > $signed(b) ? 1 : a == b ? 0 : -1);
            4'd4: ans = a << b;
            4'd5: ans = b >>> a[4:0];
            4'd6: begin
                i   = 0;
                // $display("%d", a);
                // $display("%d", b);
                // $stop;
                ans = a;
                for (i = 0; i < imm; i = i + 1) begin
                    ans[i] = ~a[i];
                end
            end
            default: ans = 0;
        endcase
    end
endmodule
