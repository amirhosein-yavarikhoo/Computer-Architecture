module memory (adr, d_in, mrd, mwr, clk, d_out);
  input [31:0] adr;
  input [31:0] d_in;
  input mrd, mwr, clk;
  output [31:0] d_out;
  
  reg [7:0] mem[0:65535];
  
  initial $readmemb("memdata1.mem", mem, 1000);
  initial $readmemb("instmem.mem", mem, 0);
  
  
  // The following initial block is for TEST PURPOSE ONLY 
  initial
    #500 $display("The content of mem[200] = %d", {mem[203], mem[202], mem[201], mem[200]});
  
  always @(posedge clk)
    if (mwr==1'b1)
      {mem[adr+3], mem[adr+2], mem[adr+1], mem[adr]} = d_in;
  
  assign d_out = (mrd==1'b1) ? {mem[adr+3], mem[adr+2], mem[adr+1], mem[adr]} : 32'd0;
  
endmodule   

