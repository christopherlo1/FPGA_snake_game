`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2024 14:49:25
// Design Name: 
// Module Name: 4_way_MUX
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MUX_4way (
    input       [1:0] control,
    input       [4:0] in0,
    input       [4:0] in1,
    input       [4:0] in2,
    input       [4:0] in3,
    output reg  [4:0] out
);

    always@(control     or
            in0         or
            in1         or
            in2         or
            in3)
    begin
        case(control)//when control is in and represents a specific binary pick and out
            2'b00:  out <= in0;
            2'b01:  out <= in1;
            2'b10:  out <= in2;
            2'b11:  out <= in3;
            //must include a default case
            default : out <= 5'b00000;
        endcase
    end
    
endmodule
