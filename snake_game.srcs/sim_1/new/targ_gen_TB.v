`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.11.2024 15:58:08
// Design Name: 
// Module Name: targ_gen_TB
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


module targ_gen_TB(

    );
    
    //inputs
    reg clk;
    reg target_reached;
    reg reset;
    reg [3:0] MSM_state;
    //outputs
    wire [7:0] pos_targ_addr_X;
    wire [6:0] pos_targ_addr_Y;
    
    //instantiation of target module, Unit Under Test
    target_generator uut(
    .clk(clk),
    .target_reached(target_reached),
    .reset(reset),
    .MSM_state(MSM_state),
    .pos_targ_addr_X(pos_targ_addr_X),
    .pos_targ_addr_Y(pos_targ_addr_Y)
    );
    
    //clk signal
initial begin
    clk = 0;
    forever #50 clk = ~clk;
end

//stimulus to simulate target reached and reset
initial begin
    target_reached = 0;
    reset = 0;
    //wait
    #100
    //input
    target_reached = 1;
    #100 //reset target reached signal after 100ns
    target_reached = 0;
    #75 //wait 75 ns for new target reached signal
    target_reached = 1;
    #100 //reset target reached signal after 100ns
    target_reached = 0;
    #50 //wait 50 ns for new target reached signal
    target_reached = 1;
    #100 //reset target reached signal after 100ns
    target_reached = 0;
    reset = 1; //show what happens when reset pressed.
    #75 //wait 75 ns for new target reached signal
    target_reached = 1;

end


endmodule
