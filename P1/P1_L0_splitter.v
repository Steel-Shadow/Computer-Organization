module splitter (
    input  [31:0] A,
    output [ 7:0] O1,
    output [ 7:0] O2,
    output [ 7:0] O3,
    output [ 7:0] O4
);
    assign O1 = A >> 24;
    assign O2 = (A << 8) >> 24;
    assign O3 = (A << 16) >> 24;
    assign O4 = A;
    
endmodule
