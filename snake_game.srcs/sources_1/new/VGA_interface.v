`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2024 13:54:49
// Design Name: 
// Module Name: VGA_interface
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


module VGA_interface(
    input                   clk,
    input      [11:0] colour_in,
    output reg [11:0] colour_out,
    output reg HS,
    output reg VS,
    output reg [9:0] X,
    output reg [8:0] Y
    );
    
    //timing for vertical lines
parameter vertTimePulseWidthEnd  = 10'd2;
parameter vertTimeBackPorchEnd   = 10'd31;
parameter vertTimeDisplayTimeEnd = 10'd511;
parameter vertTimeFrontPorchEnd  = 10'd521;

// timing for horizontal lines
parameter horzTimePulseWidthEnd  = 10'd96;
parameter horzTimeBackPorchEnd   = 10'd144;
parameter horzTimeDisplayTimeEnd = 10'd784;
parameter horzTimeFrontPorchEnd  = 10'd800;


wire Htrigg;
wire Vtrigg;
wire [9:0] Hcount;
wire [9:0] Vcount;

//counter520 Y vertical
    Generic_counter # (
        .counter_width(10), //parameters defined
        .counter_max(520)) //counts up to 520 and resets
    Vcounter(
        .clk(clk),
        .reset(1'b0),
        .enable(Htrigg),
        .trig_out(Vtrigg),
        .count(Vcount)
    );

//counter799 X horizontal
    Generic_counter # (
        .counter_width(10), //parameters defined
        .counter_max(799)) //counts up to 799 and resets
    Hcounter(
        .clk(clk),
        .reset(1'b0),
        .enable(MHz25Trigg),
        .trig_out(Htrigg),
        .count(Hcount)
     );
 
//counter25MHz
     Generic_counter # (
         .counter_width(2), //parameters defined
         .counter_max(3)) //counts up to  and resets
     counter25MHz(
         .clk(clk),
         .reset(1'b0),
         .enable(1'b1),
         .trig_out(MHz25Trigg),
         .count(MHz25Count)
      );
       
        //code for horizontal
    always@(posedge clk)begin
            if (Hcount < horzTimePulseWidthEnd)
                HS <= 0;
            else 
                HS <= 1;
        end    
           
           //code for vertical reset
     always@(posedge clk)begin
            if (Vcount < vertTimePulseWidthEnd)
                VS <= 0;
            else 
                VS <= 1;
        end           
            
       //colour out signal
    always@ (posedge clk) begin       
        if (((vertTimeBackPorchEnd < Vcount)&&(Vcount < vertTimeDisplayTimeEnd)) && ((horzTimeBackPorchEnd < Hcount)&&(Hcount < horzTimeDisplayTimeEnd)))
            colour_out <= colour_in;
        else
            colour_out <= 0;
    end
    // vga must be working at 25MHz frequency hence the counter that sends a signal every 4 counts to 100MHz cus CLK is 100MHz (in fpga)
    //address for pixels - to be decoded from two counters, not in display range = 0, in display range = count up with counters
    // Y address
    always@ (posedge clk) begin
        if ((vertTimeBackPorchEnd < Vcount)&&(Vcount < vertTimeDisplayTimeEnd))
            Y <= Vcount - vertTimeBackPorchEnd;
        else
            Y <= 0;
    end
    
    //X address
    always@ (posedge clk) begin
        if ((horzTimeBackPorchEnd < Hcount)&&(Hcount < horzTimeDisplayTimeEnd))
            X <= Hcount - horzTimeBackPorchEnd;
        else
            X <= 0;
    end    
    
endmodule
