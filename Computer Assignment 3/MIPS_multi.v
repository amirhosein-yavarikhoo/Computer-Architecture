module MIPS_multi (address_out,mem_write_data,read_data,mr,mw,clk,rst);
	input [31:0] read_data;
	output mr,mw;
	output [31:0] mem_write_data,address_out;
	input clk,rst;
	wire reg_dst,mem_to_reg,Asel,reg_write,PCWrite,PCWriteCond,ld_IR,Mem_or_I,wr31,wrdmux;
	wire [5:0] opcode,func;
	wire [1:0] Bsel,pc_src;
	wire [2:0] operation;
	datapath DP ( clk, rst, read_data,
                  mem_write_data, 
                  reg_dst, mem_to_reg, Asel ,Bsel, pc_src, operation, reg_write,
                  PCWrite, PCWriteCond, ld_IR,Mem_or_I,address_out,wr31,wrdmux,opcode,func
                 );
	controller CU(clk,rst,reg_dst, mem_to_reg, reg_write,Mem_or_I,wr31,wrdmux,pc_src,
	PCWrite, PCWriteCond,ld_IR,Bsel,Asel,mr,mw,opcode,func,operation);
endmodule

