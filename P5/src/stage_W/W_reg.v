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
    reg [31:0] pc_W;
    reg [31:0] instr_W;
    reg [31:0] rs_data_W;
    reg [31:0] rt_data_W;
    reg [31:0] ext_W;
    reg [31:0] alu_out_W;
    reg [31:0] dm_out_W;

    assign out_pc      = pc_W;
    assign out_instr   = instr_W;
    assign out_rs_data   = rs_data_W;
    assign out_rt_data   = rt_data_W;
    assign out_ext     = ext_W;
    assign out_alu_out = alu_out_W;
    assign out_dm_out  = dm_out_W;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            pc_W      <= 32'h3000;
            instr_W   <= 32'b0;
            rs_data_W   <= 32'b0;
            rt_data_W   <= 32'b0;
            ext_W     <= 32'b0;
            alu_out_W <= 32'b0;
            dm_out_W  <= 32'b0;
        end else begin
            pc_W      <= in_pc;
            instr_W   <= in_instr;
            rs_data_W   <= in_rs_data;
            rt_data_W   <= in_rt_data;
            ext_W     <= in_ext;
            alu_out_W <= in_alu_out;
            dm_out_W  <= in_dm_out;
        end
    end

endmodule
