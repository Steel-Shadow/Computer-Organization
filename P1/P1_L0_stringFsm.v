module expr (
    input            clk,
    input            clr,
    input      [7:0] in,
    output reg       out,
    output reg [2:0] s
);

    //reg [2:0] s;
    initial begin
        s<= 0;
    end

    always @(posedge clk, posedge clr) begin
        if (clr) begin
            s <= 0;
        end else begin
            case (s)
                0: s <= (in >= "0" && in <= "9") ? 1 : 5;
                1: s <= (in == "+" || in == "*") ? 2 : 5;
                2: s <= (in >= "0" && in <= "9") ? 1 : 5;
                5: s <= 5;
                default: s <= 5;
            endcase
        end
    end

    always @* begin
        out = (s == 1) ? 1 : 0;
    end
    
endmodule
