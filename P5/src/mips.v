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

    wire [ 31:0] rs_data_D;
    wire [ 31:0] rt_data_D;

    wire [  2:0] ext_op_D;  //EXT
    wire [ 31:0] ext_D;

    wire [  1:0] Tuse_rs;  //冒险处理
    wire [  1:0] Tuse_rt;
    wire [  1:0] Tnew;
    wire         stall;

    wire [ 31:0] fwd_rs_data_D;
    wire [ 31:0] fwd_rt_data_D;

    wire [  1:0] fwd_rs_data_D_op;
    wire [  1:0] fwd_rt_data_D_op;

    //////////////////////////////////////////// E
    wire [ 31:0] pc_E;
    wire [ 31:0] instr_E;
    wire [25:21] rs_E;
    wire [20:16] rt_E;
    wire [15:11] rd_E;
    wire [ 10:6] shamt_E;
    wire [ 15:0] imm_E;
    wire [ 25:0] j_address_E;

    wire [ 31:0] rs_data_E;
    wire [ 31:0] rt_data_E;

    wire [ 31:0] ext_E;

    wire         alu_b_op_E;  //ALU
    wire [  3:0] alu_op_E;
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

    wire [ 31:0] rs_data_M;
    wire [ 31:0] rt_data_M;

    wire [ 31:0] ext_M;

    wire [ 31:0] alu_out_M;

    wire         mem_write_M;  //DM
    wire [ 31:0] dm_out_M;

    wire [  1:0] Tnew_M;
    wire [  4:0] reg_addr_M;

    wire [ 31:0] give_M;

    //////////////////////////////////////////// W
    wire [ 31:0] pc_W;
    wire [ 31:0] instr_W;
    wire [25:21] rs_W;
    wire [20:16] rt_W;
    wire [15:11] rd_W;
    wire [ 10:6] shamt_W;
    wire [ 15:0] imm_W;
    wire [ 25:0] j_address_W;

    wire [ 31:0] rs_data_W;
    wire [ 31:0] rt_data_W;

    wire [ 31:0] ext_W;

    wire [ 31:0] alu_out_W;

    wire [ 31:0] dm_out_W;

    wire         reg_write_W;  //GRF写回
    wire [  2:0] reg_data_op_W;
    wire [ 31:0] reg_data_W;
    wire [  4:0] reg_addr_W;

    wire [ 31:0] give_W;
    wire [  2:0] give_W_op;

    /************   stage_F    ************/
    PC u_PC (
        .clk  (clk),
        .reset(reset),

        .next_pc_op(next_pc_op_F),
        .stall     (stall),

        .rs_data_D  (fwd_rs_data_D),  //NPC实际上在D中
        .rt_data_D  (fwd_rt_data_D),
        .imm_D      (imm_D),
        .j_address_D(j_address_D),

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


    MUX_4 u_MUX_4_fwd_rs_data_D (
        .sel  (fwd_rs_data_D_op),
        .data2(give_M),
        .data1(give_W),
        .data0(rs_data_D),

        .ans(fwd_rs_data_D)
    );

    MUX_4 u_MUX_4_fwd_rt_data_D (
        .sel  (fwd_rt_data_D_op),
        .data2(give_M),
        .data1(give_W),
        .data0(rt_data_D),

        .ans(fwd_rt_data_D)
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

        .reg_addr_E(reg_addr_E),
        .reg_addr_M(reg_addr_M),

        .Tnew_E(Tnew_E),
        .Tnew_M(Tnew_M),
        .Tnew  (Tnew),
        .stall (stall)
    );

    GRF u_GRF (
        .reset(reset),
        .clk  (clk),
        .pc   (pc_W),

        //stage_D读取
        .rs     (rs_D),
        .rt     (rt_D),
        .rs_data(rs_data_D),
        .rt_data(rt_data_D),

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

        .in_pc     (pc_D),
        .in_instr  (instr_D),
        .in_rs_data(fwd_rs_data_D),
        .in_rt_data(fwd_rt_data_D),
        .in_ext    (ext_D),
        .in_Tnew   (Tnew),

        .stall(stall),

        .out_pc     (pc_E),
        .out_instr  (instr_E),
        .out_rs_data(rs_data_E),
        .out_rt_data(rt_data_E),
        .out_ext    (ext_E),
        .out_Tnew   (Tnew_E)
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
        .rs    (rs_data_E),
        .rt    (rt_data_E),
        .ext   (ext_E),
        .alu_op(alu_op_E),

        .alu_out(alu_out_E)
    );

    /************   stage_M    ************/
    M_reg u_M_reg (
        .clk  (clk),
        .reset(reset),

        .in_pc     (pc_E),
        .in_instr  (instr_E),
        .in_rs_data(rs_data_E),
        .in_rt_data(rt_data_E),
        .in_ext    (ext_E),
        .in_alu_out(alu_out_E),
        .in_Tnew   (Tnew_E - 2'b1 > 0 ? Tnew_E - 2'b1 : 2'b0),

        .out_pc     (pc_M),
        .out_instr  (instr_M),
        .out_rs_data(rs_data_M),
        .out_rt_data(rt_data_M),
        .out_ext    (ext_M),
        .out_alu_out(alu_out_M),
        .out_Tnew   (Tnew_M),
    );

    assign give_M = alu_out_M;

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
        .mem_data     (rt_data_M),

        .dm_out(dm_out_M)
    );

    /************   stage_W    ************/

    w_reg u_w_reg (
        .clk  (clk),
        .reset(reset),

        .in_pc     (pc_M),
        .in_instr  (instr_M),
        .in_rs_data(rs_data_M),
        .in_rt_data(rt_data_M),
        .in_ext    (ext_M),
        .in_alu_out(alu_out_M),
        .in_dm_out (dm_out_M),

        .out_pc     (pc_W),
        .out_instr  (instr_W),
        .out_rs_data(rs_data_W),
        .out_rt_data(rt_data_W),
        .out_ext    (ext_W),
        .out_alu_out(alu_out_W),
        .out_dm_out (dm_out_W)
    );

    MUX_8 u_MUX_8_give_W (
        .sel  (give_W_op),
        .data0(alu_out_W),
        .data1(dm_out_W),
        .data2(pc_W + 32'd8),
        .data3(32'b0),

        .ans(give_W)
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
        .reg_data_op(reg_data_op_W),

        .give_W_op(give_W_op)
    );

    MUX_8 u_MUX_8_GRF_reg_data (  // MUX_8 GRF的reg_data选择 
        .sel(reg_data_op_W),

        .data0(alu_out_W),
        .data1(dm_out_W),
        .data2(pc_W + 32'd8),
        .data3(),

        .ans(reg_data_W)
    );
endmodule
