module PC (
    input         clk,
    input         reset,
    output [31:0] pc_out
);
    reg [31:0] pc;
    reg [31:0] next_pc;

    assign pc_out = pc;

    always @(*) begin
        next_pc = pc + 32'd4;
    end

    always @(posedge clk) begin
        if (reset) begin
            pc <= 32'h3000;
        end else begin
            pc <= next_pc;
        end
    end

endmodule
