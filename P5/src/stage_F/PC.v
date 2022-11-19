module PC (
    input       clk,
    input       reset,
    input [2:0] next_pc_op,

    input [31:0] in0,  //pc+4 
    input [31:0] in1,  //beq alu_out==0 pc<-pc+4+sign_ext_offset||00
    input [31:0] in2,  //jal PC31..28 || instr_index || 0^2
    input [31:0] in3,  //jr PC <- GPR[rs]
    input [31:0] in4,
    input [31:0] in5,
    input [31:0] in6,
    input [31:0] in7,

    output [31:0] pc_out
);
    reg [31:0] pc;

    reg [31:0] next_pc;
    always @(*) begin
        case (next_pc_op)
            3'd0: next_pc = in0;
            3'd1: next_pc = in1;
            3'd2: next_pc = in2;
            3'd3: next_pc = in3;
            3'd4: next_pc = in4;
            3'd5: next_pc = in5;
            3'd6: next_pc = in6;
            3'd7: next_pc = in7;
            default: next_pc = 0;
        endcase
    end

    assign pc_out = pc;

    always @(posedge clk) begin
        if (reset) begin
            pc <= 32'h3000;
        end else begin
            pc <= next_pc;
        end
    end

endmodule
