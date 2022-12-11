module BE (
    input [ 1:0] mem_addr,  // I	最低两位的地址
    input [31:0] mem_data,  // I	输入的 32 位数据
    input [ 2:0] dm_op,     // I	数据扩展控制码

    output reg [31:0] dm_out  // O	扩展后的 32 位数据
);
    always @(*) begin
        case (dm_op)
            3'd0: dm_out = mem_data;  // 000:无扩展
            3'd1: begin  // 001:无符号字节数据扩展
                case (mem_addr[1:0])
                    2'b00:   dm_out = {{24{1'b0}}, mem_data[7:0]};
                    2'b01:   dm_out = {{24{1'b0}}, mem_data[15:8]};
                    2'b10:   dm_out = {{24{1'b0}}, mem_data[23:16]};
                    2'b11:   dm_out = {{24{1'b0}}, mem_data[31:24]};
                    default: dm_out = 0;
                endcase
            end
            3'd2: begin  // 010:符号字节数据扩展 lb
                case (mem_addr[1:0])
                    2'b00:   dm_out = {{24{mem_data[7]}}, mem_data[7:0]};
                    2'b01:   dm_out = {{24{mem_data[15]}}, mem_data[15:8]};
                    2'b10:   dm_out = {{24{mem_data[23]}}, mem_data[23:16]};
                    2'b11:   dm_out = {{24{mem_data[31]}}, mem_data[31:24]};
                    default: dm_out = 0;
                endcase
            end
            3'd3: begin  // 011:无符号半字数据扩展
                case (mem_addr[1])
                    1'b0: dm_out = {{16{1'b0}}, mem_data[15:0]};
                    1'b1: dm_out = {{16{1'b0}}, mem_data[31:16]};
                    default: dm_out = 0;
                endcase
            end
            3'd4: begin  // 100:符号半字数据扩展 lh
                case (mem_addr[1])
                    1'b0: dm_out = {{16{mem_data[15]}}, mem_data[15:0]};
                    1'b1: dm_out = {{16{mem_data[31]}}, mem_data[31:16]};
                    default: dm_out = 0;
                endcase
            end
            default: dm_out = mem_data;
        endcase
    end
endmodule
