module BlockChecker (
    input             clk,
    input             reset,
    input      [ 7:0] in,
    output reg        result
);

    integer nBegin, nEnd, flag;
	 reg [63:0] word;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            result <= 1;
            flag   <= 0;
            word   = 64'b0;
            nBegin <= 0;
            nEnd   <= 0;
        end else begin
            if (in == " ") begin
                word = 0;
            end else begin

                if (word == "begi") nBegin <= ((in | (6'b1 << 5)) == "n") ? nBegin + 1 : nBegin;
                else if (word == "en") nEnd <= ((in | (6'b1 << 5)) == "d") ? nEnd + 1 : nEnd;
                else if (word == "begin") nBegin <= nBegin - 1;
                else if (word == "end") nEnd <= nEnd - 1;
                word = (word << 8) | in | (6'b1 << 5);
                // $display("%s nBegin:%d nEnd:%d", word, nBegin, nEnd);

                if (nBegin > nEnd) result <= 0;
                else if (nBegin == nEnd && flag == 0) result <= 1;
                else if (flag == 1 && word >> 8 == "end") begin
                    flag   <= 0;
                    result <= 1;
                end else if (nBegin < nEnd) begin
                    flag   <= flag + 1;
                    result <= 0;
                end

            end
        end
    end



endmodule
