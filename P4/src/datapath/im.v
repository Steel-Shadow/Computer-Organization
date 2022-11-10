module IM (
    input  [31:0] pc,
    output [31:0] instr
);
    // IM ÈÝÁ¿Îª 16KiB£¨4096 ¡Á 32bit£©
    // °´×ÖÑ°Ö·
    reg [31:0] inst_mem[11:0];

    assign instr = inst_mem[pc];

endmodule
