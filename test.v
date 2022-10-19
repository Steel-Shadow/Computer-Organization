module top_module (
    input  clk,
    input  reset,  // 同步复位
    input  in,
    output disc,
    output flag,
    output err
);
    reg [31:0] s;
    reg [31:0] os;
    parameter d = 21, f = 22, e = 23;

    always @(posedge clk) begin
        if (reset) begin
            s  <= 0;
            os <= 0;
        end else begin
            os <= s;
            if (s <= 4) begin
                s <= in == 1 ? s + 1 : 0;
            end else if (s == 5) begin
                s <= in == 1 ? 6 : d;
            end else if (s == d) begin
                s <= in == 1 ? 1 : 0;
            end else if (s == 6) begin
                s <= in == 1 ? e : f;
            end else if (s == f) begin
                s <= in == 1 ? 1 : 0;
            end else if (s == e) begin
                s <= in == 1 ? e : 0;
            end
        end
    end

    assign disc = os == d;
    assign flag = os == f;
    assign err  = os == e;
endmodule
