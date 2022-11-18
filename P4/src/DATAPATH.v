module DATAPATH (
    input clk,
    input reset,

    input [25:21] rs,
    input [20:16] rt,
    input [15:11] rd,
    input [ 10:6] shamt,
    input [ 15:0] imm,
    input [ 25:0] j_address,

    input [2:0] next_pc_op,

    input       reg_write,
    input       a1_op,
    input [1:0] reg_addr_op,
    input [2:0] reg_data_op,

    input [2:0] alu_op,
    input [2:0] alu_b_op,

    input mem_write,

    output [31:0] instr
);
    wire [31:0] pc;
    wire [31:0] read1;
    wire [31:0] alu_out;
    wire [ 4:0] reg_addr;
    wire [31:0] reg_data;
    wire [31:0] read2;
    wire [31:0] dm_out;
    wire [31:0] alu_b;

    //PC 
    PC u_PC (
        .clk  (clk),
        .reset(reset),

        .next_pc_op(next_pc_op),
        .in0       (pc + 32'd4),                                                                //pc+4 
        .in1       (alu_out == 32'b0 ? pc + 32'd4 + {{14{imm[15]}}, imm, 2'b00} : pc + 32'd4),  //beq alu_out==0 pc<-pc+4+sign_ext_offset||00
        .in2       ({pc[31:28], j_address, 2'b00}),                                             //jal PC31..28 || instr_index || 0^2
        .in3       (read1),                                                                     //jr PC <- GPR[rs]
        .in4       (),
        .in5       (),
        .in6       (),
        .in7       (),

        .pc_out(pc)
    );

    //IM 
    IM u_IM (
        .pc(pc),

        .instr(instr)
    );

    // MUX_4 GRF的reg_addr选择
    MUX_4 #(
        .DATA_WIDTH(5)
    ) u_MUX_4_GRF_reg_addr (
        .sel  (reg_addr_op),
        .data0(rd),
        .data1(rt),
        .data2(5'd31),
        .data3(),

        .ans(reg_addr)
    );

    // MUX_8 GRF的reg_data选择        
    MUX_8 #(
        .DATA_WIDTH(32)
    ) u_MUX_8_GRF_reg_data (
        .sel  (reg_data_op),
        .data0(alu_out),
        .data1(dm_out),
        .data2({imm, {16{1'b0}}}),
        .data3(pc + 32'd4),
        .data4({{16{alu_out[1] ? dm_out[31] : dm_out[15]}}, alu_out[1] ? dm_out[31:16] : dm_out[15:0]}),
        .data5(read1 < read2 ? 1 : 0),
        .data6(),
        .data7(),

        .ans(reg_data)
    );

    // GRF 
    GRF u_GRF (
        .reset    (reset),
        .clk      (clk),
        .pc       (pc),
        .reg_write(reg_write),
        .a1       (a1_op ? rt : rs),  //sll时选择rt
        .a2       (rt),               //rt
        .reg_addr (reg_addr),
        .reg_data (reg_data),

        .read1(read1),
        .read2(read2)
    );

    // MUX_8 alu_b选择
    MUX_8 #(
        .DATA_WIDTH(32)
    ) u_MUX_8_ALU_alu_b (
        .sel  (alu_b_op),
        .data0(read2),
        .data1({{16{imm[15]}}, imm}),
        .data2({{16{1'b0}}, imm}),
        .data3({{27{1'b0}}, shamt}),
        .data4(),
        .data5(),
        .data6(),
        .data7(),

        .ans(alu_b)
    );

    // ALU
    ALU u_ALU (
        .a     (read1),
        .b     (alu_b),
        .alu_op(alu_op),

        .alu_out(alu_out)
    );


    // DM
    DM u_DM (
        .clk          (clk),
        .reset        (reset),
        .pc           (pc),
        .mem_write    (mem_write),
        .mem_addr_byte(alu_out[13:0]),
        .mem_data     (read2),

        .dm_out(dm_out)
    );

endmodule
