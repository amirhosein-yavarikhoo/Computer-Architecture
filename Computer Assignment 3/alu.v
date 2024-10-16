module alu (a, b, ctrl, y, zero);
  input signed [31:0] a, b;
  input [2:0] ctrl;
  output reg [31:0] y;
  output zero;
  
  assign y =  (ctrl == 3'b000) ? (a & b) :
              (ctrl == 3'b001) ? (a | b) : 
              (ctrl == 3'b010) ? (a + b) :
              (ctrl == 3'b110) ? (a - b) :
	      ((a<b) ? 32'd1: 32'd0);
  
  assign zero = (y == 32'd0) ? 1'b1 : 1'b0;
  
endmodule

