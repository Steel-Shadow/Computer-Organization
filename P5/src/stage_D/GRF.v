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
�� GRF ģ���У�ÿ��ʱ�������ص���ʱ��Ҫд�����ݣ���дʹ���ź�Ϊ 1 �ҷ� reset ʱ�������д���λ�ü�д���ֵ����ʽ����ע��ո�Ϊ��
$display("@%h: $%d <= %h", WPC, Waddr, WData);
���� WPC ��ʾ��Ӧָ��Ĵ����ַ���� 0x00003000 ��ʼ��Waddr ��ʾ����� 5 λд�Ĵ����ĵ�ַ��WData ��ʾ����� 32 λд��Ĵ�����ֵ��
���� 8 λ��Ҫ���㡣
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
                $display("%d@%h: $%d <= %h", $time, pc, reg_addr, reg_data);
                registers[reg_addr] <= reg_data;
            end
        end
    end


endmodule
