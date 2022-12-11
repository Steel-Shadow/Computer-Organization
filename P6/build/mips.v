module mips (
    input clk,
    input reset,

    input  [31:0] i_inst_rdata,  //	I	i_inst_addr 对应的 32 位指令
    output [31:0] i_inst_addr,   //	O	需要进行取指操作的流水级 PC（一般为 F 级）

    input  [31:0] m_data_rdata,   // I	数据存储器存储的相应数据
    output [31:0] m_data_addr,    // O	待写入/读出的数据存储器相应地址
    output [31:0] m_data_wdata,   // O	待写入数据存储器相应数据
    output [ 3:0] m_data_byteen,  // O	四位字节使能
    output [31:0] m_inst_addr,    // O	M 级 PC

    output        w_grf_we,
    output [ 4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr
);
    /************   declaration    ************/
    //////////////////////////////////////////// F
    wire [ 31:0] instr_F;
    wire [ 31:0] pc_F;
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

    wire [  1:0] fwd_rs_data_D_op;
    wire [  1:0] fwd_rt_data_D_op;

    wire [ 31:0] fwd_rs_data_D;
    wire [ 31:0] fwd_rt_data_D;

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

    wire [  3:0] alu_op_E;  //ALU
    wire [ 31:0] alu_out_E;

    wire [  3:0] md_op;  // MD 乘除模块
    wire         start;
    wire         busy;
    wire [ 31:0] hi;
    wire [ 31:0] lo;
    wire [ 31:0] md_out_E;

    wire [  1:0] Tnew_E;
    wire [  4:0] reg_addr_E;

    wire [ 31:0] give_E;

    wire [  1:0] fwd_rs_data_E_op;
    wire [  1:0] fwd_rt_data_E_op;

    wire [ 31:0] fwd_rs_data_E;
    wire [ 31:0] fwd_rt_data_E;

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
    wire [ 31:0] md_out_M;

    //DM
    wire [  2:0] dm_op_M;
    wire [ 31:0] dm_out_M;

    wire [  1:0] Tnew_M;
    wire [  4:0] reg_addr_M;

    wire [  1:0] give_M_op;
    wire [ 31:0] give_M;

    wire         fwd_rt_data_M_op;
    wire [ 31:0] fwd_rt_data_M;

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
    wire [ 31:0] md_out_W;

    wire [ 31:0] dm_out_W;

    wire [  4:0] reg_addr_W;  //GRF写回

    wire [  2:0] give_W_op;
    wire [ 31:0] give_W;

    /************   stage_F    ************/
    assign i_inst_addr = pc_F;
    assign instr_F     = i_inst_rdata;

    PC u_PC (
        .clk  (clk),
        .reset(reset),

        .next_pc_op(next_pc_op_F),
        .stall     (stall),

        .rs_data_D  (fwd_rs_data_D),  //NPC实际上在D
        .rt_data_D  (fwd_rt_data_D),
        .imm_D      (imm_D),
        .j_address_D(j_address_D),

        .pc_out(pc_F)
    );

    /************   stage_D    ************/
    D_reg u_D_reg (
        .clk  (clk),
        .reset(reset),

        .in_pc   (pc_F),
        .in_instr(instr_F),

        .stall(stall),

        .out_pc   (pc_D),
        .out_instr(instr_D)
    );

    MUX_4 u_MUX_4_fwd_rs_data_D (
        .sel  (fwd_rs_data_D_op),
        .data3(give_E),
        .data2(give_M),
        .data1(give_W),
        .data0(rs_data_D),

        .ans(fwd_rs_data_D)
    );

    MUX_4 u_MUX_4_fwd_rt_data_D (
        .sel  (fwd_rt_data_D_op),
        .data3(give_E),
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
        .reg_addr_W(reg_addr_W),

        .Tnew_E(Tnew_E),
        .Tnew_M(Tnew_M),
        .Tnew  (Tnew),

        .busy (busy),  // MD阻塞
        .start(start),

        .stall(stall),

        .fwd_rs_data_D_op(fwd_rs_data_D_op),
        .fwd_rt_data_D_op(fwd_rt_data_D_op)

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
        .reg_data(give_W),
        .reg_addr(reg_addr_W)  //隐含 reg_write
    );

    assign w_grf_we    = 1'b1;
    assign w_grf_addr  = reg_addr_W;
    assign w_grf_wdata = give_W;
    assign w_inst_addr = pc_W;

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

    assign give_E = pc_E + 32'd8;

    MUX_4 u_MUX_4_fwd_rs_data_E (
        .sel  (fwd_rs_data_E_op),
        .data2(give_M),
        .data1(give_W),
        .data0(rs_data_E),

        .ans(fwd_rs_data_E)
    );

    MUX_4 u_MUX_4_fwd_rt_data_E (
        .sel  (fwd_rt_data_E_op),
        .data2(give_M),
        .data1(give_W),
        .data0(rt_data_E),

        .ans(fwd_rt_data_E)
    );

    CU_E u_CU_E (
        .instr(instr_E),

        .rs       (rs_E),
        .rt       (rt_E),
        .rd       (rd_E),
        .shamt    (shamt_E),
        .imm      (imm_E),
        .j_address(j_address_E),

        .alu_op(alu_op_E),
        .md_op (md_op),

        .reg_addr(reg_addr_E),

        .reg_addr_M(reg_addr_M),
        .reg_addr_W(reg_addr_W),

        .Tnew_M          (Tnew_M),
        .fwd_rs_data_E_op(fwd_rs_data_E_op),
        .fwd_rt_data_E_op(fwd_rt_data_E_op)
    );

    ALU u_ALU (
        .rs    (fwd_rs_data_E),
        .rt    (fwd_rt_data_E),
        .ext   (ext_E),
        .alu_op(alu_op_E),

        .alu_out(alu_out_E)
    );

    MD u_MD (
        .clk  (clk),
        .reset(reset),

        .md_op(md_op),
        .rs   (fwd_rs_data_E),
        .rt   (fwd_rt_data_E),

        .start (start),
        .busy  (busy),
        .hi    (hi),
        .lo    (lo),
        .md_out(md_out_E)
    );

    /************   stage_M    ************/
    M_reg u_M_reg (
        .clk  (clk),
        .reset(reset),

        .in_pc     (pc_E),
        .in_instr  (instr_E),
        .in_rs_data(fwd_rs_data_E),
        .in_rt_data(fwd_rt_data_E),
        .in_ext    (ext_E),
        .in_alu_out(alu_out_E),
        .in_md_out (md_out_E),
        .in_Tnew   (Tnew_E > 2'b1 ? Tnew_E - 2'b1 : 2'b0),

        .out_pc     (pc_M),
        .out_instr  (instr_M),
        .out_rs_data(rs_data_M),
        .out_rt_data(rt_data_M),
        .out_ext    (ext_M),
        .out_alu_out(alu_out_M),
        .out_md_out (md_out_M),
        .out_Tnew   (Tnew_M)
    );

    MUX_4 u_MUX_4_give_M (
        .sel  (give_M_op),
        .data0(pc_M + 32'd8),
        .data1(alu_out_M),
        .data2(md_out_M),

        .ans(give_M)
    );

    assign fwd_rt_data_M = (fwd_rt_data_M_op == 1'd1) ? give_W : rt_data_M;

    CU_M u_CU_M (
        .instr(instr_M),

        .rs       (rs_M),
        .rt       (rt_M),
        .rd       (rd_M),
        .shamt    (shamt_M),
        .imm      (imm_M),
        .j_address(j_address_M),

        .mem_addr     (alu_out_M),
        .fwd_rt_data  (fwd_rt_data_M),  //待处理的写入数据
        .m_data_byteen(m_data_byteen),  //四位字节使能 写入字节选择
        .dm_op        (dm_op_M),
        .m_data_wdata (m_data_wdata),   //DM 写入数据

        .reg_addr(reg_addr_M),

        .fwd_rt_data_M_op(fwd_rt_data_M_op),
        .reg_addr_W      (reg_addr_W),

        .give_M_op(give_M_op)
    );

    assign m_data_addr = alu_out_M;  //DM
    assign m_inst_addr = pc_M;

    BE u_BE (
        .mem_addr(alu_out_M[1:0]),
        .mem_data(m_data_rdata),
        .dm_op   (dm_op_M),

        .dm_out(dm_out_M)
    );

    /************   stage_W    ************/

    W_reg u_W_reg (
        .clk  (clk),
        .reset(reset),

        .in_pc     (pc_M),
        .in_instr  (instr_M),
        .in_rs_data(rs_data_M),
        .in_rt_data(fwd_rt_data_M),
        .in_ext    (ext_M),
        .in_alu_out(alu_out_M),
        .in_dm_out (dm_out_M),
        .in_md_out (md_out_M),

        .out_pc     (pc_W),
        .out_instr  (instr_W),
        .out_rs_data(rs_data_W),
        .out_rt_data(rt_data_W),
        .out_ext    (ext_W),
        .out_alu_out(alu_out_W),
        .out_dm_out (dm_out_W),
        .out_md_out (md_out_W)
    );

    MUX_8 u_MUX_8_give_W (  //兼顾转发与reg_data
        .sel  (give_W_op),
        .data0(pc_W + 32'd8),
        .data1(alu_out_W),
        .data2(md_out_W),
        .data3(dm_out_W),

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

        .reg_addr (reg_addr_W),
        .give_W_op(give_W_op)
    );

    DASM Dasm (
        .pc        (pc_W),
        .instr     (instr_W),
        .imm_as_dec(1'b1),
        .reg_name  (1'b0),
        .asm       ()
    );

endmodule
