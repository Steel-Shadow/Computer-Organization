module D_reg (
    input clk,
    input reset,

    input [31:0] in_pc,
    input [31:0] in_instr,

    output [31:0] out_pc,
    output [31:0] out_instr
);
    reg [31:0] pc_D;
    reg [31:0] instr_D;

    assign out_pc    = pc_D;
    assign out_instr = instr_D;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            pc_D    <= 32'h3000;
            instr_D <= 32'b0;
        end else begin
            pc_D    <= in_pc;
            instr_D <= in_instr;
        end
    end
endmodule
