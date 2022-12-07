module D_reg (
    input clk,
    input reset,

    input [31:0] in_pc,
    input [31:0] in_instr,

    input stall,

    output [31:0] out_pc,
    output [31:0] out_instr,

    input  in_huiwen,
    output out_huiwen
);
    reg [31:0] pc_D;
    reg [31:0] instr_D;

    reg        huiwen_D;

    assign out_pc     = pc_D;
    assign out_instr  = instr_D;
    assign out_huiwen = huiwen_D;

    always @(posedge clk) begin
        if (reset) begin
            pc_D     <= 32'h3000;
            instr_D  <= 32'b0;
            huiwen_D <= 0;
        end else begin
            if (stall) begin
                pc_D     <= pc_D;
                instr_D  <= instr_D;
                huiwen_D <= huiwen_D;
            end else begin
                pc_D     <= in_pc;
                instr_D  <= in_instr;
                huiwen_D <= in_huiwen;
            end
        end
    end
endmodule
