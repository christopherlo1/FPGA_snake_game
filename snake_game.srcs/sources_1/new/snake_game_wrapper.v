`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2024 15:17:12
// Design Name: 
// Module Name: snake_game_wrapper
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


module snake_game_wrapper(
    input reset,
    input clk,
    input btnU,
    input btnR,
    input btnD,
    input btnL,
    input pause,
    output [11:0] colour_out,
    output HS,
    output VS,
    output [3:0] SEG_SELECT_OUT,
    output [7:0] HEX_OUT,
    output [3:0] LED_out
    
    );

wire [2:0] MSM_state_out;
wire [1:0] NSM_state_out;
wire [9:0] address_X;
wire [8:0] address_Y;
wire [11:0] colour;
wire [7:0] random_target_address_X;
wire [6:0] random_target_address_Y;
wire target_reached;
wire [3:0] score;
wire lose;
wire [3:0] LED_dispSM_state;

//instantiate master state machine
MSM MSM(
.clk(clk),
.reset(reset),
.btnU(btnU), .btnR(btnR), .btnD(btnD), .btnL(btnL),
.score(score), .lose(lose), .pause(pause), .LED_dispSM_state(LED_dispSM_state),
.MSM_state_out(MSM_state_out)
);

//instantiate navigation state machine
NSM NSM(
.clk(clk),
.reset(reset),
.btnU(btnU), .btnR(btnR), .btnD(btnD), .btnL(btnL),
.NSM_state(NSM_state_out)
);

//instantiate snake control
snake_control snake_control(
.clk(clk), .reset(reset),
.MSM_state(MSM_state_out), .NSM_state(NSM_state_out),
.X(address_X), .Y(address_Y), .colour(colour),
.random_target_address_X(random_target_address_X),
.random_target_address_Y(random_target_address_Y),
.target_reached(target_reached),
.lose(lose), .pause(pause), .LED_dispSM_state(LED_dispSM_state), .LED_out(LED_out)
);

//instantiate VGA interface
top_wrapper_vga vga(
.clk(clk),
//.MSM_state(MSM_state_out),
.colour_in(colour),
.colour_out(colour_out),
.X(address_X),
.Y(address_Y),
.HS(HS),
.VS(VS)
);

//instantiate target generator
target_generator targ_gen(
.target_reached(target_reached),
.reset(reset),
.MSM_state(MSM_state_out),
.clk(clk),
.pos_targ_addr_X(random_target_address_X),
.pos_targ_addr_Y(random_target_address_Y)
);

//instantiate score counter & instantiate 7 seg display inside
score_counter score_count(
.clk(clk),
.reset(reset),
.target_reached(target_reached),
.MSM_state(MSM_state_out),
.SEG_SELECT_OUT(SEG_SELECT_OUT),
.HEX_OUT(HEX_OUT),
.score(score)
);


endmodule
