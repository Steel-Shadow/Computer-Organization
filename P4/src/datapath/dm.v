module DM (
    input         clk,
    input         reset,
    input  [31:0] pc,
    input         mem_write,
    input  [13:0] mem_addr_byte,  //字节byte地址
    input  [31:0] mem_data,
    output [31:0] dm_out
);
    // DM 容量为 12KiB（3072 × 32bit）
    // 定义为4096字 按字寻址
    reg  [31:0] data_mem [4095:0];

    wire [13:2] mem_addr;
    assign mem_addr = mem_addr_byte[13:2];

    assign dm_out   = data_mem[mem_addr];

    integer i;
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 4096; i = i + 1) begin
                data_mem[i] <= 32'b0;
            end
        end else begin
            if (mem_write) begin
                $display("@%h: *%h <= %h", pc, {18'b0, mem_addr_byte}, mem_data);
                data_mem[mem_addr] <= mem_data;
            end
        end
    end
endmodule
