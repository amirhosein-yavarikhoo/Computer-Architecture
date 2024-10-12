`timescale 1ns/1ns

module tb();
    reg [4:0] inbus = 0;
    reg clk = 0, rst = 0, start = 0;
    wire [9:0] result;
    wire done, ready; 
    booth_mul mult(inbus, clk , rst, start, done,ready , result);
    initial begin
        repeat (1000) #40 clk = ~clk;
    end
    initial begin 
        rst = 1;
        #80 rst = 0;
        #320 start = 1;
        #80 inbus = $random;
        start = 0 ;
        #80 inbus = $random;
        
        #1600 start = 1;
        #80 inbus = $random;
        start = 0 ;
        #80 inbus = $random;
        
        #1600 start = 1;
        #80 inbus = $random;
        start = 0 ;
        #80 inbus = $random;
        
        #1600 start = 1;
        #80 inbus = $random;
        start = 0 ;
        #80 inbus = $random;
        
        #1600 start = 1;
        #80 inbus = $random;
        start = 0 ;
        #80 inbus = $random;
        
        

        #8000 $stop;
    end

endmodule
