module GRF (
    input         reset,
    input         clk,
    input  [31:0] pc,
    input         reg_write,
    input  [ 4:0] rs,
    input  [ 4:0] rt,
    input  [ 4:0] reg_addr,
    input  [31:0] reg_data,
    output [31:0] rs_data,
    output [31:0] rt_data
);
    /*
在 GRF 模块中，每个时钟上升沿到来时若要写入数据（即写使能信号为 1 且非 reset 时）则输出写入的位置及写入的值，格式（请注意空格）为：
$display("@%h: $%d <= %h", WPC, Waddr, WData);
其中 WPC 表示相应指令的储存地址，从 0x00003000 开始；Waddr 表示输入的 5 位写寄存器的地址；WData 表示输入的 32 位写入寄存器的值。
不足 8 位需要补零。
*/
    reg [31:0] registers[31:0];

    assign rs_data = (reg_addr == rs & rs != 5'd0) ? reg_data : registers[rs];
    assign rt_data = (reg_addr == rt & rt != 5'd0) ? reg_data : registers[rt];

    integer i;
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 0;
            end
        end else begin
            if (reg_write & (reg_addr != 5'd0)) begin
                // $display("%d@%h: $%d <= %h", $time, pc, reg_addr, reg_data);
                $display("@%h: $%d <= %h", pc, reg_addr, reg_data);
                registers[reg_addr] <= reg_data;
            end
        end
    end


endmodule
