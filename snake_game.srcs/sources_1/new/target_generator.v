`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2024 16:03:49
// Design Name: 
// Module Name: target_generator
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


module target_generator(
    input target_reached,
    input reset,
    input clk,
    input [3:0] MSM_state,
    output reg [7:0] pos_targ_addr_X, //position of the target (X,Y)
    output reg [6:0] pos_targ_addr_Y
    );
    
    //inputs to shift register from amd (randomness thing)
    wire in_X = gen_targ_X[7]~^gen_targ_X[5]~^gen_targ_X[4]~^gen_targ_X[3];
    wire in_Y = gen_targ_Y[6]~^gen_targ_Y[5];
    
    //positions of the target?
    reg [7:0] gen_targ_X;
    reg [6:0] gen_targ_Y;
    
    //initial values for the target position and generation
    //X
    initial begin
        pos_targ_addr_X = 8'b00010101;
        gen_targ_X = 8'b00100110;
    end
    
    //Y
    initial begin
        pos_targ_addr_Y = 7'b0010101;
        gen_targ_Y = 7'b0010010;
    end
    

//shift register for X
    always@ (posedge clk) begin
        if (reset)
            gen_targ_X <= 8'd0;
        else begin
            gen_targ_X <= {gen_targ_X[6:0],in_X};
        end
    end
    
//shift register for Y
    always@ (posedge clk) begin
        if (reset)
            gen_targ_Y <= 7'd0;
        else begin
            gen_targ_Y <= {gen_targ_X[5:0],in_Y};
        end
    end    
    
//upload generate targets to target positions when target is reached by snake
    always@ (posedge clk) begin
        if (target_reached) begin //when snake eats target begin
            if (gen_targ_X < 160) //when the address is less than 160 go to new generated address
                pos_targ_addr_X <= gen_targ_X;
            else if  (pos_targ_addr_X >= 160)
                pos_targ_addr_X <= 10;
            else // if the address is greater than 160 it will go off the screen so reset it.
                pos_targ_addr_X <= 10;
                
            if (gen_targ_Y < 120) //the same for Y but max Y = 120
                pos_targ_addr_Y <= gen_targ_Y;
            else if  (pos_targ_addr_Y >= 120)
                pos_targ_addr_Y <= 10;
            else
                pos_targ_addr_Y <= 80;
        end
        else if (reset) begin //make the targets go to a fixed position upon reset
            pos_targ_addr_X <= 60;
            pos_targ_addr_Y <= 60;
        end            
    end
        
endmodule
