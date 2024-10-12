module asu (input [9:0] y, p,input mode, output reg [9:0] s);
    always @(mode,y,p) begin
        s = 0;
        if (mode) s = p + y;
        else s = p - y;
    end
    //m determines adding (1) or subtracting (0)
endmodule
