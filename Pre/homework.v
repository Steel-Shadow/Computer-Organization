`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Company:
//Engineer:
//
//CreateDate:09:55:3809/29/2022
//DesignName:
//ModuleName:homework
//ProjectName:
//TargetDevices:
//Toolversions:
//Description:
//
//Dependencies:
//
//Revision:
//Revision0.01-FileCreated
//AdditionalComments:
//
//////////////////////////////////////////////////////////////////////////////////
module hw (
    input  A,B,C,
    output Y
);
    assign Y = (A & B) | (A & C) | (B & C);
endmodule




























