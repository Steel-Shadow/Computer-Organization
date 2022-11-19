module EXT (
    input [2:0] ext_op,

    input [15:0] imm,
    input [ 4:0] shamt,

    output reg [31:0] ext
);
    always @(*) begin
        case (ext_op)
            3'd0: ext = {{16{imm[15]}}, imm};  //sign_ext imm
            3'd1: ext = {{16{1'b0}}, imm};  //zero_ext imm
            3'd2: ext = {{27{1'b0}}, shamt};  //zero_ext shamt
            default: ;  //z
        endcase
    end
endmodule
