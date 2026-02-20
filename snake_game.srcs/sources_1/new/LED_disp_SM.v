`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2024 14:25:16
// Design Name: 
// Module Name: LED_disp_SM
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


module LED_disp_SM(
    input clk,
    input reset,
    input [1:0] MSM_state,
    output [3:0] LED_out,
    output [3:0] LED_dispSM_state,
    output lose_out
    );
    
    //for counter code
reg [32:0] current_count; //26 binary bits to represent 50million
reg [32:0] next_count;
    
    //for the state machine code
reg [3:0] current_state;
reg [3:0] next_state;

reg [7:0] current_LEDs;
reg [7:0] next_LEDs;

reg current_lose;
reg next_lose;

assign lose_out = current_lose;
assign LED_dispSM_state = current_state;
assign LED_out = current_LEDs;

    //sequential logic
    always@ (posedge clk) begin
        if(reset) begin
            current_state <= 4'b0000;
            current_count <= 0;
            current_LEDs <= 4'b0000;
            current_lose <= 0; //everything to 0, no lights no counting status no nothinggg.
        end
        else begin
            current_state <= next_state;
            current_count <= next_count;
            current_LEDs <= next_LEDs;
            current_lose <= next_lose;
        end
    end
    
    //combinational logic
    always@ (current_state or MSM_state or current_count) begin
        case (current_state)
            //idle state
            4'h0: begin
                //if the master state machine state is not for LEDs stay in idle
                if (MSM_state == 2'b11)
                    next_state <= 4'h1;
                else
                    next_state <= 4'h0;
                    
                next_count <= 0;
                next_LEDs <= 4'b0000;
                next_lose <= 1'b0;
            end
            
            //state 1 - will only come here when master activated led state machine
            4'h1: begin
                if (current_count == 100000000 && MSM_state == 2'b11) begin
                    next_state <= 4'h2; //goes to state 2
                    next_count <= 0; //counter goes back to 0 for the next state
                end
                else begin
                    next_state <= current_state; //stays in state 1 so when going into case itll come back here
                    next_count <= current_count + 1; //counter, will feedback loop until counter = 500000000
                end
                next_LEDs <= 4'b0001;
            end
            
            //state 2
            4'h2: begin
                if (current_count == 100000000) begin
                    next_state <= 4'h3; //goes to state 3
                    next_count <= 0;
                end
                else begin
                    next_state <= current_state;
                    next_count <= current_count + 1;
                end
                next_LEDs <= 4'b0010;
            end            
            
            //state 3
            4'h3: begin
                if (current_count == 100000000) begin
                    next_state <= 4'h4; //goes to state 4
                    next_count <= 0;
                end
                else begin
                    next_state <= current_state;
                    next_count <= current_count + 1;
                end
                next_LEDs <= 4'b0100;
            end        
            
            //state 4
            4'h4: begin
                if (current_count == 100000000) begin
                    next_state <= 4'h9; //goes to state 9
                    next_count <= 0;
                end
                else begin
                    next_state <= current_state;
                    next_count <= current_count + 1;
                end
                next_LEDs <= 4'b1000;
            end         
            
            //state finished
            4'h9: begin
                if (current_count == 100000) begin
                    next_state <= 4'h0; //goes back to state 0 (idle)
                    next_count <= 0;
                end
                else begin
                    next_state <= current_state;
                    next_count <= current_count + 1;
                end
                next_LEDs <= 4'b0000;
                next_lose <= 1'b1; //output a lose signal saying timer is finished
            end        
            
            default: next_state <= 4'h0;
                                                                                               
        endcase
    end
endmodule
