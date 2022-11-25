module IM (
    input  [31:0] pc,
    output [31:0] instr
);
    // IM 容量为 16KiB（4096 × 32bit）
    // 按字寻址
    initial begin
        $readmemh("code.txt", inst_mem);
    end

    reg  [31:0] inst_mem [4095:0];

    wire [31:0] pc_index;

    assign pc_index = pc - 32'h3000;
    assign instr    = inst_mem[pc_index[13:2]];

endmodule
