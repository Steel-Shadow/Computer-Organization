module D_reg (
    input clk,
    input reset,

    input [31:0] in_pc,
    input [31:0] in_instr,

    input stall,

    output [31:0] out_pc,
    output [31:0] out_instr
);
    reg [31:0] pc_D;
    reg [31:0] instr_D;

    assign out_pc    = pc_D;
    assign out_instr = instr_D;

    always @(posedge clk) begin
        if (reset) begin
            pc_D    <= 32'h3000;
            instr_D <= 32'b0;
        end else begin
            if (stall) begin
                pc_D    <= pc_D;
                instr_D <= instr_D;
            end else begin
                pc_D    <= in_pc;
                instr_D <= in_instr;
            end
        end
    end
endmodule
