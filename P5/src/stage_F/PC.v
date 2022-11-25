module PC (
    input clk,
    input reset,

    input [2:0] next_pc_op,
    input       stall,

    input [31:0] rs_data_D,
    input [31:0] rt_data_D,
    input [15:0] imm_D,
    input [25:0] j_address_D,

    output [31:0] pc_out
);
    reg [31:0] pc;  //pc_F
    reg [31:0] next_pc;

    assign pc_out = pc;

    always @(*) begin
        if (stall) next_pc = pc;
        else begin
            case (next_pc_op)
                3'd1:  //beq rs==rt pc<-pc+4+sign_ext_offset||00
                next_pc = (rs_data_D == rt_data_D) ? pc + {{14{imm_D[15]}}, imm_D, 2'b00} : pc + 32'd4;
                3'd2:  //jal PC31..28 || instr_index || 0^2 
                next_pc = {pc[31:28], j_address_D, 2'b00};
                3'd3:  //jr PC <- GPR[rs]
                next_pc = rs_data_D;
                default: next_pc = pc + 32'd4;
            endcase
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            pc <= 32'h3000;
        end else begin
            pc <= next_pc;
        end
    end

endmodule
