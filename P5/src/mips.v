module mips (
    input clk,
    input reset
);
    /************   declaration    ************/
    //////////////////////////////////////////// F
    wire [ 31:0] pc_F;
    wire [ 31:0] instr_F;
    wire [25:21] rs_F;
    wire [20:16] rt_F;
    wire [15:11] rd_F;
    wire [ 10:6] shamt_F;
    wire [ 15:0] imm_F;
    wire [ 25:0] j_address_F;

    wire [  2:0] next_pc_op_F;

    //////////////////////////////////////////// D
    wire [ 31:0] pc_D;
    wire [ 31:0] instr_D;
    wire [25:21] rs_D;
    wire [20:16] rt_D;
    wire [15:11] rd_D;
    wire [ 10:6] shamt_D;
    wire [ 15:0] imm_D;
    wire [ 25:0] j_address_D;

    wire         a1_op_D;  //GRF读取
    wire [ 31:0] read1_D;
    wire [ 31:0] read2_D;

    wire [  2:0] ext_op_D;  //EXT
    wire [ 31:0] ext_D;

    wire [  1:0] Tuse_rs;  //冒险处理
    wire [  1:0] Tuse_rt;
    wire [  1:0] Tnew;
    wire         stall;

    //////////////////////////////////////////// E
    wire [ 31:0] pc_E;
    wire [ 31:0] instr_E;
    wire [25:21] rs_E;
    wire [20:16] rt_E;
    wire [15:11] rd_E;
    wire [ 10:6] shamt_E;
    wire [ 15:0] imm_E;
    wire [ 25:0] j_address_E;

    wire [ 31:0] read1_E;
    wire [ 31:0] read2_E;

    wire [ 31:0] ext_E;

    wire         alu_b_op_E;  //ALU
    wire [  2:0] alu_op_E;
    wire [ 31:0] alu_out_E;

    wire [  1:0] Tnew_E;
    wire [  4:0] reg_addr_E;

    //////////////////////////////////////////// M
    wire [ 31:0] pc_M;
    wire [ 31:0] instr_M;
    wire [25:21] rs_M;
    wire [20:16] rt_M;
    wire [15:11] rd_M;
    wire [ 10:6] shamt_M;
    wire [ 15:0] imm_M;
    wire [ 25:0] j_address_M;

    wire [ 31:0] read1_M;
    wire [ 31:0] read2_M;

    wire [ 31:0] ext_M;

    wire [ 31:0] alu_out_M;

    wire         mem_write_M;  //DM
    wire [ 31:0] dm_out_M;

    wire [  1:0] Tnew_M;
    wire [  4:0] reg_addr_M;

    //////////////////////////////////////////// W
    wire [ 31:0] pc_W;
    wire [ 31:0] instr_W;
    wire [25:21] rs_W;
    wire [20:16] rt_W;
    wire [15:11] rd_W;
    wire [ 10:6] shamt_W;
    wire [ 15:0] imm_W;
    wire [ 25:0] j_address_W;

    wire [ 31:0] read1_W;
    wire [ 31:0] read2_W;

    wire [ 31:0] ext_W;

    wire [ 31:0] alu_out_W;

    wire [ 31:0] dm_out_W;

    wire         reg_write_W;  //GRF写回
    wire [  2:0] reg_data_op_W;
    wire [ 31:0] reg_data_W;
    wire [  4:0] reg_addr_W;

    /************   stage_F    ************/
    PC u_PC (
        .clk  (clk),
        .reset(reset),

        .next_pc_op(next_pc_op_F),
        .in0       (pc_F + 32'd4),                                                                        //in0~7
        .in1       (read1_D == read2_D ? pc_D + 32'd8 + {{14{imm_D[15]}}, imm_D, 2'b00} : pc_D + 32'd8),
        .in2       ({pc_D[31:28], j_address_D, 2'b00}),                                                   //jal PC31..28 || instr_index || 0^2
        .in3       (read1_D),                                                                             //jr PC <- GPR[rs]

        .stall(stall),

        .pc_out(pc_F)
    );

    IM u_IM (
        .pc(pc_F),

        .instr(instr_F)
    );

    /************   stage_D    ************/
    D_reg u_D_reg (
        .clk  (clk),
        .reset(reset),

        .in_pc   (pc_F),
        .in_instr(instr_F),

        .out_pc   (pc_D),
        .out_instr(instr_D)
    );

    CU_D u_CU_D (
        .instr(instr_D),

        .rs       (rs_D),
        .rt       (rt_D),
        .rd       (rd_D),
        .shamt    (shamt_D),
        .imm      (imm_D),
        .j_address(j_address_D),

        .next_pc_op(next_pc_op_F),

        .ext_op(ext_op_D),

        .a1_op(a1_op_D),

        .Tnew (Tnew),
        .stall(stall)
    );

    GRF u_GRF (
        .reset(reset),
        .clk  (clk),
        .pc   (pc_W),

        //stage_D读取
        .a1   (a1_op_D ? rt_D : rs_D),
        .a2   (rt_D),
        .read1(read1_D),
        .read2(read2_D),

        //stage_W写回
        .reg_write(reg_write_W),
        .reg_data (reg_data_W),
        .reg_addr (reg_addr_W)
    );

    EXT u_EXT (
        .ext_op(ext_op_D),
        .imm   (imm_D),
        .shamt (shamt_D),

        .ext(ext_D)
    );

    /************   stage_E    ************/
    E_reg u_E_reg (
        .clk  (clk),
        .reset(reset),

        .in_pc   (pc_D),
        .in_instr(instr_D),
        .in_read1(read1_D),
        .in_read2(read2_D),
        .in_ext  (ext_D),
        .in_Tnew (Tnew),

        .out_pc   (pc_E),
        .out_instr(instr_E),
        .out_read1(read1_E),
        .out_read2(read2_E),
        .out_ext  (ext_E),
        .out_Tnew (Tnew_E)
    );

    CU_E u_CU_E (
        .instr(instr_E),

        .rs       (rs_E),
        .rt       (rt_E),
        .rd       (rd_E),
        .shamt    (shamt_E),
        .imm      (imm_E),
        .j_address(j_address_E),

        .alu_b_op(alu_b_op_E),
        .alu_op  (alu_op_E),

        .reg_addr(reg_addr_E)
    );

    ALU u_ALU (
        .a     (read1_E),
        .b     (alu_b_op_E ? ext_E : read2_E),
        .alu_op(alu_op_E),

        .alu_out(alu_out_E)
    );

    /************   stage_M    ************/
    M_reg u_M_reg (
        .clk  (clk),
        .reset(reset),

        .in_pc     (pc_E),
        .in_instr  (instr_E),
        .in_read1  (read1_E),
        .in_read2  (read2_E),
        .in_ext    (ext_E),
        .in_alu_out(alu_out_E),
        .in_Tnew   (Tnew_E - 2'b1 > 0 ? Tnew_E - 2'b1 : 2'b0),

        .out_pc     (pc_M),
        .out_instr  (instr_M),
        .out_read1  (read1_M),
        .out_read2  (read2_M),
        .out_ext    (ext_M),
        .out_alu_out(alu_out_M),
        .out_Tnew   (Tnew_M)
    );

    CU_M u_CU_M (
        .instr(instr_M),

        .rs       (rs_M),
        .rt       (rt_M),
        .rd       (rd_M),
        .shamt    (shamt_M),
        .imm      (imm_M),
        .j_address(j_address_M),
        .mem_write(mem_write_M),

        .reg_addr(reg_addr_M)
    );

    DM u_DM (
        .clk          (clk),
        .reset        (reset),
        .pc           (pc_M),
        .mem_write    (mem_write_M),
        .mem_addr_byte(alu_out_M[13:0]),
        .mem_data     (read2_M),

        .dm_out(dm_out_M)
    );

    /************   stage_W    ************/

    w_reg u_w_reg (
        .clk  (clk),
        .reset(reset),

        .in_pc     (pc_M),
        .in_instr  (instr_M),
        .in_read1  (read1_M),
        .in_read2  (read2_M),
        .in_ext    (ext_M),
        .in_alu_out(alu_out_M),
        .in_dm_out (dm_out_M),

        .out_pc     (pc_W),
        .out_instr  (instr_W),
        .out_read1  (read1_W),
        .out_read2  (read2_W),
        .out_ext    (ext_W),
        .out_alu_out(alu_out_W),
        .out_dm_out (dm_out_W)
    );

    CU_W u_CU_W (
        .instr(instr_W),

        .rs       (rs_W),
        .rt       (rt_W),
        .rd       (rd_W),
        .shamt    (shamt_W),
        .imm      (imm_W),
        .j_address(j_address_W),

        .reg_write  (reg_write_W),
        .reg_addr   (reg_addr_W),
        .reg_data_op(reg_data_op_W)
    );

    MUX_8 u_MUX_8_GRF_reg_data (  // MUX_8 GRF的reg_data选择 
        .sel  (reg_data_op_W),
        .data0(alu_out_W),
        .data1(dm_out_W),
        .data2(pc_W + 32'd8),
        .data3(),
        .ans  (reg_data_W)
    );
endmodule
