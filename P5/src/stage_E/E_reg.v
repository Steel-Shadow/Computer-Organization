module E_reg (
    input clk,
    input reset,
    
    input [31:0] in_pc,
    input [31:0] in_instr,
    input [31:0] in_read1,
    input [31:0] in_read2,
    input [31:0] in_ext,

    output [31:0] out_pc,
    output [31:0] out_instr,
    output [31:0] out_read1,
    output [31:0] out_read2,
    output [31:0] out_ext
);
    reg [31:0] pc_E;
    reg [31:0] instr_E;
    reg [31:0] read1_E;
    reg [31:0] read2_E;
    reg [31:0] ext_E;

    assign out_pc    = pc_E;
    assign out_instr = instr_E;
    assign out_read1 = read1_E;
    assign out_read2 = read2_E;
    assign out_ext   = ext_E;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            pc_E    <= 32'h3000;
            instr_E <= 32'b0;
            read1_E <= 32'b0;
            read2_E <= 32'b0;
            ext_E   <= 32'b0;
        end else begin
            pc_E    <= in_pc;
            instr_E <= in_instr;
            read1_E <= in_read1;
            read2_E <= in_read2;
            ext_E   <= in_ext;
        end
    end
endmodule
