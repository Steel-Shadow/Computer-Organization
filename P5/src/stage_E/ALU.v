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

    always @(*) begin
        case (alu_op)
            4'd0: ans = rs + rt;  //add
            4'd1: ans = rs - rt;  //sub
            4'd2: ans = rs | ext;  //ori
            4'd3: ans = rs + ext;  //lw sw
            4'd4: ans = ext << 5'd16;  //lui
            4'd5: ans = rt << ext;  //sll
            4'd6: ans = rs + ext;  //addi
            4'd7: ans = (rs + ext) << 2;  //可能出错的alu
            4'd8: begin
                temp = rt[4:0];

                if (rt[0] == 1'b0) begin
                    //GPR[rd] ← GPR[rs](s-1)...0 || GPR[rs]31...s
                    ans = (rs << (32 - temp)) | (rs >> temp);
                end else begin
                    //GPR[rd] ← GPR[rs](31-s)...0 || GPR[rs]31...(32-s)
                    ans = (rs >> (32 - temp)) | (rs << temp);
                end

            end
            default: ans = 0;
        endcase

    end
endmodule
