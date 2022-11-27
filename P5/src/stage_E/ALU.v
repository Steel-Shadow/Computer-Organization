module ALU (
    input  [31:0] rs,
    input  [31:0] rt,
    input  [31:0] ext,
    input  [ 3:0] alu_op,
    output [31:0] alu_out
);
    //+ - | compare(>1 ==0 <-1) 有符号比较
    reg [31:0] ans;

    assign alu_out = ans;

    always @(*) begin
        case (alu_op)
            4'd0: ans = rs + rt;  //add
            4'd1: ans = rs - rt;  //sub
            4'd2: ans = rs | ext;  //ori
            4'd3: ans = rs + ext;  //lw sw
            4'd4: ans = ext << 5'd16;  //lui
            4'd5: ans = rt << ext;  //sll
            default: ans = 0;
        endcase
        // if (add) alu_op = 4'd0;
        // else if (sub) alu_op = 4'd1;
        // else if (ori) alu_op = 4'd2;
        // else if (lw | sw) alu_op = 4'd3;
        // else if (lui) alu_op = 4'd4;
        // else if (sll) alu_op = 4'd5;
        // else alu_op = 4'd0;
    end
endmodule
