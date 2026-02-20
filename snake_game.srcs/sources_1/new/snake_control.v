`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     
// Engineer: Cheuk Lahm Christopher Lo
// 
// Create Date: 14.11.2024 16:19:48
// Design Name: 
// Module Name: snake_control
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


module snake_control(
    input [2:0] MSM_state,
    input [1:0] NSM_state,
    input clk,
    input reset,
    input [9:0] X,
    input [8:0] Y,
    input [7:0] random_target_address_X,
    input [6:0] random_target_address_Y,
    input pause,
    output reg [11:0] colour,
    output reg target_reached,
    output reg lose,
    output [3:0] LED_dispSM_state,
    output [3:0] LED_out
    );
    
wire [31:0] waitcount;
wire [31:0] snake_speed_count;

//instantiate generic counter to slow down the snake movement
Generic_counter # (
.counter_width(32),
.counter_max(5000000))
snake_speed(
.clk(clk),
.reset(1'b0),
.enable(1'b1),
.trig_out(snake_speed_trig),
.count(snake_speed_count)
);

//delay to start hurting itself
    Generic_counter # (
    .counter_width(32),
    .counter_max(10000000))
    waitcounter(
    .clk(clk),
    .reset(reset),
    .enable(snake_speed_trig && MSM_state == 2'b01),
    .trig_out(waittrig),
    .count(waitcount)
    );
    
//parameters for the snake
parameter snake_length = 30;
reg [4:0] snake_length_real = 5;

//for loop for snake tail
integer i;

//loop for snake die
integer j;

//snake position (head)
reg [7:0] snake_X [0 : snake_length-1];
reg [6:0] snake_Y [0 : snake_length-1];

//code for idle state, play state and win state
always@ (posedge clk) begin
    if(reset)
        snake_length_real = 5;
    else begin
        case (MSM_state)
            2'b00: begin //idle state
                if((X >= 160 && X <= 170) && (Y >= 120 && Y <= 280)||
                (X >= 100 && X <= 230) && (Y >= 120 && Y <= 130)||
                (X >= 100 && X <= 230) && (Y >= 270 && Y <= 280))
                
                    colour <= 12'hfff;
                else
                    colour <= 12'hfff;
            end
            
            2'b01: begin //play state
                if(X[9:2] == snake_X[0] && Y[8:2] == snake_Y[0])
                    colour <= 12'hff0; //yellow snake
                else if(X[9:2] == random_target_address_X && Y[8:2] == random_target_address_Y)
                    colour <= 12'hf00; //red target
                else
                    colour <= 12'h00f; // blue background    
                //snake colour tail
                for(i = 0; i < snake_length_real; i = i + 1) begin
                    if (X[9:2] == snake_X[i] && Y[8:2] == snake_Y[i])
                        colour <= 12'hff0;                         
                end       
            end
            
            3'b100: begin //pause
                if(X[9:2] == snake_X[0] && Y[8:2] == snake_Y[0])
                    colour <= 12'hff0; //yellow snake
                else if(X[9:2] == random_target_address_X && Y[8:2] == random_target_address_Y)
                    colour <= 12'hf00; //red target
                else
                    colour <= 12'h00f; // blue background    
                //snake colour tail
                for(i = 0; i < snake_length_real; i = i + 1) begin
                    if (X[9:2] == snake_X[i] && Y[8:2] == snake_Y[i])
                        colour <= 12'hff0;  
                end
            end
            
            2'b10: begin //win
                if ((X >= 200 && X <= 470)&&(Y >= 350 && Y <= 360) ||
                (X >= 200 && X <= 210)&&(Y >= 120 && Y <= 360) || 
                (X >= 330 && X <= 340)&&(Y >= 220 && Y <= 360) ||
                (X >= 460 && X <= 470)&&(Y >= 120 && Y <= 360))
                    colour <= 12'hf00;          
                else
                    colour <= 12'hf00;
            end
            
            2'b11: begin //lose                
                if ((X >= 330 && X <= 470)&&(Y >= 350 && Y <= 360) ||
                (X >= 330 && X <= 340)&&(Y >= 120 && Y <= 360))
                    colour <= 12'h000;
                else
                    colour <= 12'h000;
            end
        endcase

 //snake gets longer when it eats a target
    if((snake_X[0] == random_target_address_X) && (snake_Y[0] == random_target_address_Y)) begin
        target_reached <= 1'b1;
        snake_length_real <= snake_length_real + 1;
    end
    else
        target_reached <= 1'b0;
    end //end for else statement at beginning
end

//for LEDS
                LED_disp_SM leds(
                .clk(clk),
                .reset(reset),
                .MSM_state(MSM_state),
                .LED_out(LED_out),
                .LED_dispSM_state(LED_dispSM_state),
                .lose_out(lose_out)
                );

//logic for if the snake touches edge it dies
always@ (posedge clk) begin
    if (reset || pause || lose_out == 1'b1)//reset lose signal when lose_out (timer finishes = 1)
        lose <= 0;       
    else begin
        if (snake_X[0]==0||snake_X[0]==160)
            lose <= 1;
        else if (snake_Y[0]==0||snake_Y[0]==120)
            lose <= 1;
    end
end

//logic for snake movement
always@ (posedge clk) begin
    if (reset||MSM_state == 2'b11) begin
        snake_X[0] <= 60;
        snake_Y[0] <= 40;
    end
    
    else if (MSM_state == 2'b01) begin //play state
        if (snake_speed_trig == 1) begin
            case (NSM_state)
                
                2'b00: begin //up
                    if(snake_Y[0] == 9'd0) begin
                        snake_X[0] <= snake_X[0];
                        snake_Y[0] <= 9'd120;
                    end
                    else begin
                        snake_X[0] <= snake_X[0];
                        snake_Y[0] <= snake_Y[0]-1;
                    end    
                end
                
                2'b01: begin //right
                    if(snake_X[0] == 10'd160) begin
                        snake_X[0] <= 10'd0;
                        snake_Y[0] <= snake_Y[0];
                    end
                    else begin
                        snake_X[0] <= snake_X[0]+1;
                        snake_Y[0] <= snake_Y[0];
                    end                   
                end
                
                2'b10: begin //down
                    if(snake_Y[0] == 9'd120) begin
                        snake_X[0] <= snake_X[0];
                        snake_Y[0] <= 9'd0;
                    end
                    else begin
                        snake_X[0] <= snake_X[0];
                        snake_Y[0] <= snake_Y[0]+1;
                    end     
                end
                
                2'b11: begin //left
                    if(snake_X[0] == 10'd0) begin
                        snake_X[0] <= 10'd160;
                        snake_Y[0] <= snake_Y[0];
                    end
                    else begin
                        snake_X[0] <= snake_X[0]-1;
                        snake_Y[0] <= snake_Y[0];
                    end     
                end
                
                default: begin
                    snake_X[0] <= snake_X[0];
                    snake_Y[0] <= snake_Y[0];
                end
                
            endcase
        end
    end
end

//shift register so the snake moves
genvar PixNo;
generate
    for (PixNo = 0; PixNo < snake_length - 1; PixNo = PixNo + 1)
        begin: PixShift
            always@ (posedge clk) begin
                if (reset) begin
                    snake_X[PixNo+1] <= 80;
                    snake_Y[PixNo+1] <= 50;
                end
                else if (snake_speed_trig == 1) begin
                    snake_X[PixNo+1] <= snake_X[PixNo];
                    snake_Y[PixNo+1] <= snake_Y[PixNo];
                end
            end
        end
endgenerate
    
endmodule