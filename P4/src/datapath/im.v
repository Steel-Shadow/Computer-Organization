module IM (
    input  [31:0] pc,
    output [31:0] instr
);
    // IM ÈÝÁ¿Îª 16KiB£¨4096 ¡Á 32bit£©
    // °´×ÖÑ°Ö·
    initial begin
        $readmemh("test_add.txt");
    end

    reg [31:0] inst_mem[4095:0];

    assign instr = inst_mem[pc[13:2]];

endmodule
