module CU_M (
    input [31:0] instr,

    output [25:21] rs,
    output [20:16] rt,
    output [15:11] rd,
    output [ 10:6] shamt,
    output [ 15:0] imm,
    output [ 25:0] j_address,

    input      [31:0] mem_addr,
    input      [31:0] fwd_rt_data,
    output reg [ 2:0] dm_op,
    output reg [ 3:0] m_data_byteen,
    output reg [31:0] m_data_wdata,

    output reg [4:0] reg_addr,  //判断冒险

    output reg [1:0] give_M_op,

    input      [4:0] reg_addr_W,
    output reg       fwd_rt_data_M_op
);
    wire [5:0] op = instr[31:26];
    assign rs    = instr[25:21];
    assign rt    = instr[20:16];
    assign rd    = instr[15:11];
    assign shamt = instr[10:6];
    wire [5:0] func = instr[5:0];
    assign imm       = instr[15:0];
    assign j_address = instr[25:0];

    wire R = (op == 6'b000000);

    wire add = R & (func == 6'b100000);
    wire sub = R & (func == 6'b100010);
    wire jr = R & (func == 6'b001000);
    wire sll = R & (func == 6'b000000);

    wire ori = (op == 6'b001101);
    wire lw = (op == 6'b100011);
    wire sw = (op == 6'b101011);
    wire beq = (op == 6'b000100);
    wire lui = (op == 6'b001111);
    wire jal = (op == 6'b000011);

    //P6额外添加指令
    wire instr_and = R & (func == 6'b100100);
    wire instr_or = R & (func == 6'b100101);
    wire slt = R & (func == 6'b101010);
    wire sltu = R & (func == 6'b101011);

    wire andi = (op == 6'b001100);
    wire addi = (op == 6'b001000);
    wire lb = (op == 6'b100000);
    wire lh = (op == 6'b100001);
    wire sb = (op == 6'b101000);
    wire sh = (op == 6'b101001);

    wire bne = (op == 6'b000101);

    wire mult = R & (func == 6'b011000);
    wire multu = R & (func == 6'b011001);
    wire div = R & (func == 6'b011010);
    wire divu = R & (func == 6'b011011);

    wire mfhi = R & (func == 6'b010000);
    wire mflo = R & (func == 6'b010010);
    wire mthi = R & (func == 6'b010001);
    wire mtlo = R & (func == 6'b010011);

    wire cal_r = (add | sub | sll | instr_and | instr_or | slt | sltu);
    wire cal_i = (ori | lui | addi | andi);
    wire load = (lw | lb | lh);
    wire store = (sw | sb | sh);
    wire md = (mult | multu | div | divu);

    always @(*) begin
        if (0) dm_op = 3'd1;  //无符号字节数据扩展
        else if (lb) dm_op = 3'd2;  //符号字节数据扩展
        else if (0) dm_op = 3'd3;  //无符号半字数据扩展
        else if (lh) dm_op = 3'd4;  //符号半字数据扩展
        else dm_op = 3'd0;  //无扩展

        if (sw) m_data_byteen = 4'b1111;
        else if (sh) m_data_byteen = mem_addr[1] ? 4'b1100 : 4'b0011;
        else if (sb) begin
            case (mem_addr[1:0])
                2'b00:   m_data_byteen = 4'b0001;
                2'b01:   m_data_byteen = 4'b0010;
                2'b10:   m_data_byteen = 4'b0100;
                2'b11:   m_data_byteen = 4'b1000;
                default: m_data_byteen = 4'b0000;
            endcase
        end else m_data_byteen = 4'b0000;

        if (sb) begin  //lb
            case (mem_addr[1:0])
                2'b00:   m_data_wdata = fwd_rt_data << 5'd0;
                2'b01:   m_data_wdata = fwd_rt_data << 5'd8;
                2'b10:   m_data_wdata = fwd_rt_data << 5'd16;
                2'b11:   m_data_wdata = fwd_rt_data << 5'd24;
                default: m_data_wdata = fwd_rt_data;
            endcase
        end else if (sh) begin  //lh
            case (mem_addr[1])
                1'b0:    m_data_wdata = fwd_rt_data << 5'd0;
                1'b1:    m_data_wdata = fwd_rt_data << 5'd16;
                default: m_data_wdata = fwd_rt_data;
            endcase
        end else if (sw) m_data_wdata = fwd_rt_data;
        else m_data_wdata = fwd_rt_data;

        if (jal) give_M_op = 2'd0;  //pc_M+8
        else if (cal_r | cal_i) give_M_op = 2'd1;  //alu_out_M
        else if (mfhi | mflo) give_M_op = 2'd2;  //md_out_M
        else give_M_op = 2'd0;

        //reg_addr 
        if (cal_r | mfhi | mflo) reg_addr = rd;  //rd
        else if (load | cal_i) reg_addr = rt;  //rt
        else if (jal) reg_addr = 5'd31;  //$ra $31
        else reg_addr = 5'd0;  //$0

        /********* forward ***********************/
        if (rt == reg_addr_W & rt != 5'd0) fwd_rt_data_M_op = 1'd1;
        else fwd_rt_data_M_op = 1'd0;
    end
endmodule
