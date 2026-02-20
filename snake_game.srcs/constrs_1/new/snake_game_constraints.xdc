
# this file is an example of a .xdc for the BASYS3 

#inputs
set_property package_pin W19 [get_ports btnL]
    set_property iostandard lvcmos33 [get_ports btnL]
set_property package_pin T18 [get_ports btnU]
    set_property iostandard lvcmos33 [get_ports btnU]
set_property package_pin T17 [get_ports btnR]
    set_property iostandard lvcmos33 [get_ports btnR]
set_property package_pin U17 [get_ports btnD]
        set_property iostandard lvcmos33 [get_ports btnD]
set_property package_pin U18 [get_ports reset]
    set_property iostandard lvcmos33 [get_ports reset]
set_property package_pin R2 [get_ports pause]
    set_property iostandard lvcmos33 [get_ports pause]
    
#get clock signal from the board
set_property package_pin W5 [get_ports {clk}]
    set_property iostandard lvcmos33 [get_ports {clk}]
    
#outputs
#vga
#blue
    set_property package_pin n18 [get_ports {colour_out[0]}]
        set_property iostandard lvcmos33 [get_ports {colour_out[0]}]
    set_property package_pin l18 [get_ports {colour_out[1]}]
        set_property iostandard lvcmos33 [get_ports {colour_out[1]}]
    set_property package_pin k18 [get_ports {colour_out[2]}]
        set_property iostandard lvcmos33 [get_ports {colour_out[2]}]  
    set_property package_pin j18 [get_ports {colour_out[3]}]
        set_property iostandard lvcmos33 [get_ports {colour_out[3]}]
#green      
    set_property package_pin j17 [get_ports {colour_out[4]}]
        set_property iostandard lvcmos33 [get_ports {colour_out[4]}]
    set_property package_pin h17 [get_ports {colour_out[5]}]
        set_property iostandard lvcmos33 [get_ports {colour_out[5]}]
    set_property package_pin g17 [get_ports {colour_out[6]}]
        set_property iostandard lvcmos33 [get_ports {colour_out[6]}]
    set_property package_pin d17 [get_ports {colour_out[7]}]
        set_property iostandard lvcmos33 [get_ports {colour_out[7]}] 
#red      
    set_property package_pin g19 [get_ports {colour_out[8]}]
        set_property iostandard lvcmos33 [get_ports {colour_out[8]}]
    set_property package_pin h19 [get_ports {colour_out[9]}]
        set_property iostandard lvcmos33 [get_ports {colour_out[9]}]
    set_property package_pin j19 [get_ports {colour_out[10]}]
        set_property iostandard lvcmos33 [get_ports {colour_out[10]}]
    set_property package_pin n19 [get_ports {colour_out[11]}]
        set_property iostandard lvcmos33 [get_ports {colour_out[11]}]
#HS
    set_property package_pin p19 [get_ports HS]
        set_property iostandard lvcmos33 [get_ports {HS}]
#VS    
    set_property package_pin r19 [get_ports {VS}]
        set_property iostandard lvcmos33 [get_ports {VS}]
        
#7 seg
    #Segment slection out    
    set_property PACKAGE_PIN U2 [get_ports {SEG_SELECT_OUT[0]}]
        set_property IOSTANDARD LVCMOS33 [get_ports {SEG_SELECT_OUT[0]}]    
    set_property PACKAGE_PIN U4 [get_ports {SEG_SELECT_OUT[1]}]
        set_property IOSTANDARD LVCMOS33 [get_ports {SEG_SELECT_OUT[1]}]
    set_property PACKAGE_PIN V4 [get_ports {SEG_SELECT_OUT[2]}]
        set_property IOSTANDARD LVCMOS33 [get_ports {SEG_SELECT_OUT[2]}]    
    set_property PACKAGE_PIN W4 [get_ports {SEG_SELECT_OUT[3]}]
        set_property IOSTANDARD LVCMOS33 [get_ports {SEG_SELECT_OUT[3]}]  
    
    #Hexidecimal LED output
    set_property PACKAGE_PIN W7 [get_ports {HEX_OUT[0]}]
        set_property IOSTANDARD LVCMOS33 [get_ports {HEX_OUT[0]}]
    set_property PACKAGE_PIN W6 [get_ports {HEX_OUT[1]}]
        set_property IOSTANDARD LVCMOS33 [get_ports {HEX_OUT[1]}]
    set_property PACKAGE_PIN U8 [get_ports {HEX_OUT[2]}]
        set_property IOSTANDARD LVCMOS33 [get_ports {HEX_OUT[2]}]
    set_property PACKAGE_PIN V8 [get_ports {HEX_OUT[3]}]
        set_property IOSTANDARD LVCMOS33 [get_ports {HEX_OUT[3]}]
    set_property PACKAGE_PIN U5 [get_ports {HEX_OUT[4]}]
        set_property IOSTANDARD LVCMOS33 [get_ports {HEX_OUT[4]}]
    set_property PACKAGE_PIN V5 [get_ports {HEX_OUT[5]}]
        set_property IOSTANDARD LVCMOS33 [get_ports {HEX_OUT[5]}]
    set_property PACKAGE_PIN U7 [get_ports {HEX_OUT[6]}]
        set_property IOSTANDARD LVCMOS33 [get_ports {HEX_OUT[6]}]
        
    #DOT LED
    set_property PACKAGE_PIN V7 [get_ports {HEX_OUT[7]}]
        set_property IOSTANDARD LVCMOS33 [get_ports {HEX_OUT[7]}]
        
#LED for timer thing black screen
    set_property package_pin u16 [get_ports {LED_out[0]}]
        set_property iostandard lvcmos33 [get_ports {LED_out[0]}]
    set_property package_pin e19 [get_ports {LED_out[1]}]
        set_property iostandard lvcmos33 [get_ports {LED_out[1]}]
    set_property package_pin u19 [get_ports {LED_out[2]}]
        set_property iostandard lvcmos33 [get_ports {LED_out[2]}]  
    set_property package_pin v19 [get_ports {LED_out[3]}]
        set_property iostandard lvcmos33 [get_ports {LED_out[3]}]