module w_reg (
    input clk,
    input reset,

    input [31:0] in_pc,
    input [31:0] in_instr,
    input [31:0] in_rs_data,
    input [31:0] in_rt_data,
    input [31:0] in_ext,
    input [31:0] in_alu_out,
    input [31:0] in_dm_out,

    output [31:0] out_pc,
    output [31:0] out_instr,
    output [31:0] out_rs_data,
    output [31:0] out_rt_data,
    output [31:0] out_ext,
    output [31:0] out_alu_out,
    output [31:0] out_dm_out
);
    reg [31:0] pc_M;
    reg [31:0] instr_M;
    reg [31:0] rs_data_M;
    reg [31:0] rt_data_M;
    reg [31:0] ext_M;
    reg [31:0] alu_out_M;
    reg [31:0] dm_out_M;

    assign out_pc      = pc_M;
    assign out_instr   = instr_M;
    assign out_rs_data   = rs_data_M;
    assign out_rt_data   = rt_data_M;
    assign out_ext     = ext_M;
    assign out_alu_out = alu_out_M;
    assign out_dm_out  = dm_out_M;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            pc_M      <= 32'h3000;
            instr_M   <= 32'b0;
            rs_data_M   <= 32'b0;
            rt_data_M   <= 32'b0;
            ext_M     <= 32'b0;
            alu_out_M <= 32'b0;
            dm_out_M  <= 32'b0;
        end else begin
            pc_M      <= in_pc;
            instr_M   <= in_instr;
            rs_data_M   <= in_rs_data;
            rt_data_M   <= in_rt_data;
            ext_M     <= in_ext;
            alu_out_M <= in_alu_out;
            dm_out_M  <= in_dm_out;
        end
    end

endmodule
