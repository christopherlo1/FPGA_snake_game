`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2024 16:01:33
// Design Name: 
// Module Name: NSM
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


module NSM(//navigation state machine
    input clk,
    input reset,
    input btnU,
    input btnR,
    input btnD,
    input btnL,
    output [1:0] NSM_state
    );
    
    reg [1:0] current_NSM_state;
    reg [1:0] next_NSM_state;
    assign NSM_state = current_NSM_state;
    
    //sequential logic
    always@ (posedge clk) begin
        if (reset)
            current_NSM_state <= 2'b00;      
        else
            current_NSM_state <= next_NSM_state;    
    end
    
    //combinational logic
    always@ (current_NSM_state or btnU or btnR or btnD or btnL) begin
        case (current_NSM_state)
        
        2'b00: begin //up
            if (btnU)
                next_NSM_state <= 2'b00;
            else if (btnR)
                next_NSM_state <= 2'b01;
            else if (btnD)
                next_NSM_state <= current_NSM_state;
            else if (btnL)
                next_NSM_state <= 2'b11;
            else
                next_NSM_state <= current_NSM_state;
        end
        2'b01: begin //right
            if (btnU)
                next_NSM_state <= 2'b00;
            else if (btnR)
                next_NSM_state <= 2'b01;
            else if (btnD)
                next_NSM_state <= 2'b10;
            else if (btnL)
                next_NSM_state <= current_NSM_state;
            else
                next_NSM_state <= current_NSM_state;        
        end
        
        2'b10: begin //down
            if (btnU)
                next_NSM_state <= current_NSM_state;
            else if (btnR)
                next_NSM_state <= 2'b01;
            else if (btnD)
                next_NSM_state <= 2'b10;
            else if (btnL)
                next_NSM_state <= 2'b11;
            else
                next_NSM_state <= current_NSM_state;        
            end
        2'b11: begin //left
            if (btnU)
                next_NSM_state <= 2'b00;
            else if (btnR)
                next_NSM_state <= current_NSM_state;
            else if (btnD)
                next_NSM_state <= 2'b10;
            else if (btnL)
                next_NSM_state <= 2'b11;
            else
                next_NSM_state <= current_NSM_state;        
        end
        
        endcase
    end
    
endmodule
