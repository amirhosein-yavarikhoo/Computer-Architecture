module mips_tb;
 wire [31:0] address_out,mem_write_data,read_data;
 wire mr,mw;
 reg clk,rst;
 MIPS_multi Processor (address_out,mem_write_data,read_data,mr,mw,clk,rst);
 memory MEM (address_out, mem_write_data, mr, mw, clk, read_data);
  initial
  begin
    rst = 1'b1;
    clk = 1'b0;
    #20 rst = 1'b0;
    #3000 $stop;
  end
  
  always
  begin
    #2 clk = ~clk;
  end
  
endmodule


