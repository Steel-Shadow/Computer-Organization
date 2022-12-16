module MUX_4 #(
    parameter DATA_WIDTH = 32
) (
    input [1:0] sel,

    input [DATA_WIDTH-1:0] data0,
    input [DATA_WIDTH-1:0] data1,
    input [DATA_WIDTH-1:0] data2,
    input [DATA_WIDTH-1:0] data3,

    output reg [DATA_WIDTH-1:0] ans
);
    always @(*) begin
        case (sel)
            3'b000: ans = data0;
            3'b001: ans = data1;
            3'b010: ans = data2;
            3'b011: ans = data3;
        endcase
    end

endmodule

module MUX_8 #(
    parameter DATA_WIDTH = 32
) (
    input [2:0] sel,

    input [DATA_WIDTH-1:0] data0,
    input [DATA_WIDTH-1:0] data1,
    input [DATA_WIDTH-1:0] data2,
    input [DATA_WIDTH-1:0] data3,
    input [DATA_WIDTH-1:0] data4,
    input [DATA_WIDTH-1:0] data5,
    input [DATA_WIDTH-1:0] data6,
    input [DATA_WIDTH-1:0] data7,

    output reg [DATA_WIDTH-1:0] ans
);
    always @(*) begin
        case (sel)
            3'b000: ans = data0;
            3'b001: ans = data1;
            3'b010: ans = data2;
            3'b011: ans = data3;
            3'b100: ans = data4;
            3'b101: ans = data5;
            3'b110: ans = data6;
            3'b111: ans = data7;
        endcase
    end

endmodule
