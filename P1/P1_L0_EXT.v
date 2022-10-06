module ext (
    input      [15:0] imm,
    input      [ 1:0] EOp,
    output reg [31:0] ext
);
    reg [1:0] temp[31:0][31:0];
    always @(*) begin
        case (EOp)
            0: ext = {{16{imm[15]}}, imm};
            1: ext = {{16{1'b0}}, imm};
            2: ext = {imm, {16{0}}};
            3: ext = {imm, {16{0}}} << 2;
            default: ;
        endcase
    end
endmodule
