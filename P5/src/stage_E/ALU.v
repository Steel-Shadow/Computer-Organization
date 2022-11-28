module ALU (
    input  [31:0] rs,
    input  [31:0] rt,
    input  [31:0] ext,
    input  [ 3:0] alu_op,
    output [31:0] alu_out
);
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
            4'd6: ans = rs + ext;  //addi
            default: ans = 0;
        endcase

    end
endmodule
