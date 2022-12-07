module ALU (
    input  [31:0] rs,
    input  [31:0] rt,
    input  [31:0] ext,
    input  [ 3:0] alu_op,
    output [31:0] alu_out
);
    reg [31:0] ans;
    reg [ 4:0] temp;

    assign alu_out = ans;

    wire [32:0] ext_33 = {1'b1, ext};
    wire [32:0] rs_33 = {rs[31], rs};
    wire [32:0] temp = ext_33 + rs_33;

    always @(*) begin
        case (alu_op)
            4'd0: ans = rs + rt;  //add
            4'd1: ans = rs - rt;  //sub
            4'd2: ans = rs | ext;  //ori
            4'd3: ans = rs + ext;  //lw sw
            4'd4: ans = ext << 5'd16;  //lui
            4'd5: ans = rt << ext;  //sll
            4'd6: ans = rs + ext;  //addi
            4'd7: begin
                if (temp[32] != temp[31]) ans = ext;
                else ans = temp;
            end
            default: ans = 0;
        endcase

    end
endmodule
