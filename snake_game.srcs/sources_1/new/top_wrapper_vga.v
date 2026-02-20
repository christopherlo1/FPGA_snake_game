`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2024 13:11:54
// Design Name: 
// Module Name: top_wrapper_vga
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


module top_wrapper_vga( //to put where the pixels are
    input clk,
  //  input [1:0] MSM_state,//input from the master state machine
    input [11:0] colour_in,
    output [11:0] colour_out,
    output HS,
    output VS,
    output [9:0] X,
    output [8:0] Y
    );
  
// all the code for the vga win and stuff is inside the snake control module  
  
    VGA_interface
    VGA_interface(
    .clk(clk),
    .colour_in(colour_in),
    .colour_out(colour_out),
    .HS(HS),
    .VS(VS),
    .X(X),
    .Y(Y)
    );

endmodule
