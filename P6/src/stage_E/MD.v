module MD (
    input clk,
    input reset,

    input [ 3:0] md_op,
    input [31:0] rs,
    input [31:0] rt,

    output start,
    output busy,

    output reg [31:0] hi,
    output reg [31:0] lo,

    output [31:0] md_out
);
    reg [ 3:0] md_op_reg;
    reg [31:0] rs_reg;
    reg [31:0] rt_reg;
    reg [ 3:0] cnt;  // busy计时器

    reg [ 3:0] next_cnt;
    reg [31:0] next_hi;
    reg [31:0] next_lo;

    // mult, multu, div, divu, mfhi, mflo, mthi, mtlo
    assign start  = (md_op != 4'd0 & md_op <= 4'd4);
    assign busy   = (cnt != 4'b0);

    assign md_out = (md_op == 4'd5) ? hi : (md_op == 4'd6) ? lo : 32'b0;

    always @(*) begin
        //next_cnt
        if (md_op == 4'd1 | md_op == 4'd2) next_cnt = 4'd5;  //mult multu
        else if (md_op == 4'd3 | md_op == 4'd4) next_cnt = 4'd10;  // div divu
        else if (busy) next_cnt = cnt - 4'd1;
        else next_cnt = 4'd0;

        //next_hi next_lo 
        if (md_op_reg == 4'd1 & cnt == 4'd1)  //mult
            {next_hi, next_lo} = $signed(rs_reg) * $signed(rt_reg);
        else if (md_op_reg == 4'd2 & cnt == 4'd1)  //multu
            {next_hi, next_lo} = rs_reg * rt_reg;
        else if (md_op_reg == 4'd3 & cnt == 4'd1) begin  //div
            next_hi = $signed(rs_reg) % $signed(rt_reg);
            next_lo = $signed(rs_reg) / $signed(rt_reg);
        end else if (md_op_reg == 4'd4 & cnt == 4'd1) begin  //divu
            next_hi = rs_reg % rt_reg;
            next_lo = rs_reg / rt_reg;
        end else if (md_op == 4'd7) begin
            next_hi = rs;
            next_lo = lo;
        end else if (md_op == 4'd8) begin
            next_hi = hi;
            next_lo = rs;
        end else begin
            next_hi = hi;
            next_lo = lo;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            md_op_reg <= 4'b0;
            cnt       <= 4'b0;
            hi        <= 32'b0;
            lo        <= 32'b0;
            rs_reg    <= 32'b0;
            rt_reg    <= 32'b0;
        end else begin  // 在运算结果保存到 HI 寄存器和 LO 寄存器后，Busy 位清除为 0。
            md_op_reg <= start ? md_op : md_op_reg;
            cnt       <= next_cnt;
            hi        <= next_hi;
            lo        <= next_lo;
            rs_reg    <= start ? rs : rs_reg;
            rt_reg    <= start ? rt : rt_reg;
        end
    end

endmodule
