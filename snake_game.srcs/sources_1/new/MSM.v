`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2024 15:19:03
// Design Name: 
// Module Name: MSM
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


module MSM(//master state machine
    input clk,
    input reset,
    input btnU,
    input btnR,
    input btnD,
    input btnL, 
    input [3:0] score,
    input lose,
    input pause,
    input [3:0] LED_dispSM_state,
    output [2:0] MSM_state_out
    );

    assign MSM_state_out = current_MSM_state;
    reg [2:0] current_MSM_state;
    reg [2:0] next_MSM_state;
    
    //sequential logic
    always@ (posedge clk) begin
        //reset if reset then MSM_state goes to state 0 (idle)
        if (reset) begin
            current_MSM_state <= 3'b000;
        end
        else begin
            current_MSM_state <= next_MSM_state;
        end
    end
    
    //combinational logic
    always@ (current_MSM_state or btnU or btnR or btnD or btnL or score or lose or pause or LED_dispSM_state) begin
        case (current_MSM_state)                  
            2'b00: begin //idle state
                if (btnU || btnR || btnD || btnL)
                    next_MSM_state <= 2'b01;               
                else
                    next_MSM_state <= current_MSM_state;
            end
            
            2'b01: begin //play
                if (pause)
                    next_MSM_state <= 3'b100;
                else if (score >= 3)
                    next_MSM_state <= 2'b10;
                else if (lose == 1)
                    next_MSM_state <= 2'b11;
                else 
                    next_MSM_state <= current_MSM_state;
            end
            
            2'b10: begin //win
                next_MSM_state <= current_MSM_state;           
            end
            
            2'b11: begin //lose
                if (LED_dispSM_state == 4'h9 && lose == 0) begin
                    next_MSM_state <= 2'b01;
                end
                else
                    next_MSM_state <= current_MSM_state;
            end
            
            3'b100: begin //pause
                if (pause)
                    next_MSM_state <= 3'b100;
                else
                    next_MSM_state <= 2'b01;
            end
           
            default: next_MSM_state <= 2'b01;
            
        endcase
    
    end
endmodule
