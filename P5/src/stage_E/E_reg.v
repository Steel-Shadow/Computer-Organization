module E_reg (
    input clk,
    input reset,

    input [31:0] in_pc,
    input [31:0] in_instr,
    input [31:0] in_rs_data,
    input [31:0] in_rt_data,
    input [31:0] in_ext,
    input [ 1:0] in_Tnew,

    input stall,

    output [31:0] out_pc,
    output [31:0] out_instr,
    output [31:0] out_rs_data,
    output [31:0] out_rt_data,
    output [31:0] out_ext,
    output [ 1:0] out_Tnew
);
    reg [31:0] pc_E;
    reg [31:0] instr_E;
    reg [31:0] rs_data_E;
    reg [31:0] rt_data_E;
    reg [31:0] ext_E;
    reg [ 1:0] Tnew_E;

    assign out_pc      = pc_E;
    assign out_instr   = instr_E;
    assign out_rs_data = rs_data_E;
    assign out_rt_data = rt_data_E;
    assign out_ext     = ext_E;
    assign out_Tnew    = Tnew_E;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            pc_E      <= 32'h3000;
            instr_E   <= 32'b0;
            rs_data_E <= 32'b0;
            rt_data_E <= 32'b0;
            ext_E     <= 32'b0;
            Tnew_E    <= 2'b0;
        end else begin
            pc_E      <= stall ? 32'h3000 : in_pc;
            instr_E   <= stall ? 32'b0 : in_instr;
            rs_data_E <= stall ? 32'b0 : in_rs_data;
            rt_data_E <= stall ? 32'b0 : in_rt_data;
            ext_E     <= stall ? 32'b0 : in_ext;
            Tnew_E    <= stall ? 2'b0 : in_Tnew;
        end
    end
endmodule
