`timescale 1ns / 1ps

module equation (
    input         clk,
    input         reset,
    input   [7:0] in,
    output   reg  out
);

    reg [1:0] s1;
    reg [2:0] s2;    
    
    reg [1:0] ns1;
    reg [2:0] ns2;

    reg [1:0] type;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            s1 <= 0;
            s2 <= 0;
        end else begin
            s1<=ns1;
            s2<=ns2;
        end 
    end

    always @(*) begin

        if ((in>="a"&&in<="z")||(in>="A"&&in<="Z")) begin
            type=1;
        end else if (in>="0"&&in<="9") begin
            type=1;
        end else if (in=="+"||in=="-"||in=="*"||in=="/") begin
            type=2;
        end else if (in=="=") begin
            type=3;
        end 
        else type = 0 ;

        case (s1)
            0: 
            if (type==1) begin
                ns1=1;
            end else if (type==3);
            else begin
                ns1=3;
            end
            1: if (type==2) begin
                ns1=2; 
            end else if (type==3) begin
                ns1=0;
            end
            else begin
                ns1=3;
            end
            2:
            if (type==1) begin
                ns1=1;
            end else ns1=3;
            default: ;
        endcase

        case(s2)
            0:
            if (ns1==1) begin
                ns2=1;
            end
            1:
            if (ns1==0 && type==3) begin
                ns2=2;
            end else if(ns1==2) ns2=0;
            else ns2=7;
            2:
            if (type==3) begin
                ns2=4;
            end else if (ns1==1) begin
                ns2=3;
            end else if(ns1==3)
                ns2=4;
            3: 
            if (type==3) begin
                ns2=4;
            end else if(ns1==1) ns2=3;
            else if (ns1==2) begin
                ns2=2;
            end else if(ns1==3) ns2=4;
            default: ;
        endcase 

        out=(s2==3)?1:0;
    end
endmodule
