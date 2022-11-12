module IM (
    input  [31:0] pc,
    output [31:0] instr
);
    // IM ÈÝÁ¿Îª 16KiB£¨4096 ¡Á 32bit£©
    // °´×ÖÑ°Ö·
    initial begin
        $readmemh("code.txt", inst_mem);
    end

    reg  [31:0] inst_mem [1023:0];

    wire [31:0] pc_index;
    
    assign pc_index = pc - 32'h3000;
    assign instr    = inst_mem[pc_index[13:2]];

endmodule
