`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2024 22:40:56
// Design Name: 
// Module Name: score_counter
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


module score_counter(
    input clk,
    input reset,
    input target_reached,
    input [1:0] MSM_state,
    output [3:0] SEG_SELECT_OUT,
    output [7:0] HEX_OUT,
    output reg [3:0] score
    );
    
    wire bit17triggout;
    wire [1:0] strobe_count; 
    
    initial score = 0;
    
    wire [4:0] DecCountAndDot0;  //counter input
    wire [4:0] DecCountAndDot1;
    wire [4:0] DecCountAndDot2;
    wire [4:0] DecCountAndDot3;
    
    wire [3:0] DecCount0; //add dot later
    wire [3:0] DecCount1;
    wire [3:0] DecCount2;
    wire [3:0] DecCount3;
    
    wire [4:0] MuxOut;
    
    wire bit4triggout1;
    wire bit4triggout2;
    wire halfcountertriggout;
    
    /*tie each counter output which tells us where the dot is*/
    
    assign DecCountAndDot0 = {1'b0, DecCount0};
    assign DecCountAndDot1 = {1'b0, DecCount1};
    assign DecCountAndDot2 = {1'b0, DecCount2}; //dot after 2nd digit to show sec and millisec
    assign DecCountAndDot3 = {1'b0, DecCount3};
    
    //make score counter internally for MSM
    always@ (posedge clk) begin
        if(reset)
            score <= 0;
        else if (target_reached && halfcountertriggout)
            score <= score + 1;
    end
    
    //17 bit counter for display refresh (strobing effect)
    Generic_counter # (
        .counter_width(17), //parameters defined
        .counter_max(99999)) //counts up to 99999 and resets
    bit17counter(
        .clk(clk),
        .reset(1'b0),
        .enable(1'b1),
        .count(bit17count),
        .trig_out(bit17triggout)
    );             
    
    //2 bit counter (strobing effect on segment display
    Generic_counter # (
    .counter_width(1), //parameters defined
    .counter_max(1))
    strobecounter(
    .clk(clk),
    .reset(reset),
    .enable(bit17triggout),
    .count(strobe_count)
    );     
    
    //1bit counter to half clock frequency (stops the counter for counting twice
    //because head and target meet for more than 1 clk
    Generic_counter # (
    .counter_width(1), //parameters defined
    .counter_max(1)
    )
    halfcounter(
    .clk(clk),
    .reset(1'b0),
    .enable(1'b1),
    .trig_out(halfcountertriggout),
    .count(halfcountcount)
    ); 
    
    //4 bit counter 1 for 1s place 0-9
    Generic_counter # (
        .counter_width(4), //parameters defined
        .counter_max(9)
        )
        bit4counter1(
        .clk(clk),
        .reset(reset),
        .enable(target_reached && halfcountertriggout),
        .trig_out(bit4triggout1),
        .count(DecCount0)
    ); 

    //4 bit counter 2 for 10s place 0-1
   Generic_counter # (
        .counter_width(4), //parameters defined
        .counter_max(1))
    bit4counter2(
        .clk(clk),
        .reset(reset),
        .enable(bit4triggout1),
        .count(DecCount1),
        .trig_out(bit4triggout2)
        );
    
    //instantiate mux
    MUX_4way MUX4(
        .control(strobe_count),//let the strobe count pick the mux output
        .in0(DecCountAndDot0),//inputs tied to decimal count
        .in1(DecCountAndDot1),
        .in2(DecCountAndDot2),
        .in3(DecCountAndDot3),
        .out(MuxOut)
        );
        
   //instantiate 7 segment decoder display
    Decoding_the_world_2 Seg7(
        .SEG_SELECT_IN(strobe_count),
        .BIN_IN(MuxOut [3:0]),
        .DOT_IN(MuxOut [4]),
        .SEG_SELECT_OUT(SEG_SELECT_OUT),
        .HEX_OUT(HEX_OUT)
    );
endmodule
