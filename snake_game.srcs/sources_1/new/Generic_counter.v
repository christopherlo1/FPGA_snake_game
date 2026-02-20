`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2024 14:32:02
// Design Name: 
// Module Name: Generic_counter
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
module Generic_counter(
//i/o defined after parameters so only ports are listed
    clk,
    reset,
    enable,
    trig_out,
    count
    );
    //parameters control the variability of each module
    parameter counter_width = 4;
    parameter counter_max = 9;
    //in/out
    input   clk;
    input   reset;
    input   enable;
    output  trig_out;
    output  [counter_width-1 : 0]count;
    
    //declare registers that hold the current count value and trigger out between clk cycles
    reg [counter_width-1 : 0] count_value;
    reg trigger_out;
    
    //synchronous logic for value of count_value 
    always@(posedge clk) begin
        if (reset)
            count_value <= 0; //when reset pressed count value = 0
        else begin
            if(enable) begin
                if(count_value == counter_max)
                    count_value <= 0; //when countvalue reaches 9 goes to 0 (obviously)
                else   
                    count_value <= count_value + 1;
            end
        end
    end 
   
   //synchronous logic for trigger_out
    always@(posedge clk) begin
        if(reset)
            trigger_out <= 0;
        else begin
            if(enable && (count_value == counter_max))
                trigger_out <= 1; //when the count value = 9  and counting the trigger is enabled
                // so the fpga goes to the next digit
            else
                trigger_out <= 0;
        end
    end
    
//assign count and trig_out outputs to 
//count_value and trigger_out variable registers
    assign count = count_value;
    assign trig_out = trigger_out;
    
endmodule
