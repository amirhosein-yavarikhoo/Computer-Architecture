module datapath ( clk, rst, mem_read,
                  mem_write_data, 
                  reg_dst, mem_to_reg, Asel ,Bsel, pc_src, alu_ctrl, reg_write,
                  PCWrite, PCWriteCond, ld_IR,Mem_or_I,mem_address,wr31,wrdmux,opcode,func
                 );
  input  clk, rst;
  output [31:0] mem_address;
  output [5:0] opcode,func;
  input  [31:0] mem_read;
  output [31:0] mem_write_data;
  input  reg_dst, mem_to_reg, reg_write,Mem_or_I,wr31,wrdmux;
  input  [1:0] pc_src;
  input  [2:0] alu_ctrl;
  wire zero;
  input PCWrite, PCWriteCond;
  input ld_IR;
  input [1:0] Bsel;
  input Asel;
  wire [31:0] pc_out;
  wire [31:0] read_data1, read_data2;
  wire [31:0] sgn_ext_out;
  wire [31:0] alu_out;
  wire [27:0] shl2_out;
  wire [31:0] mux4_out,mux6_out;
  wire [31:0] areg_out, breg_out;
  wire [31:0] IR_out, MDR_out, alu_reg_out;
  wire [31:0] pc_in;
  wire [31:0] shl2_1_out;
  wire [4:0]  mux1_out,mux2_out;
  wire [31:0] Alu_inA,Alu_inB;


  assign pc_write = PCWrite | (PCWriteCond & zero);

  reg_32b A (read_data1, rst, clk,areg_out ),
          B (read_data2, rst, clk, breg_out),
          MDR(mem_read, rst,clk, MDR_out),
          ALU_out_reg(alu_out, rst, clk, alu_reg_out);
   
  reg_32b_l IR(mem_read, rst, ld_IR, clk, IR_out),PC(pc_in, rst, pc_write, clk, pc_out);

  mux2to1_32b MUX_3 (pc_out,alu_reg_out,Mem_or_I,mem_address);

  mux2to1_5b MUX_1(IR_out[20:16], IR_out[15:11], reg_dst, mux1_out);

  mux2to1_5b MUX_2(mux1_out,5'd31,wr31,mux2_out);

  mux2to1_32b MUX_6(mux4_out,pc_out,wrdmux,mux6_out);

  reg_file  RF(mux4_out, IR_out[25:21], IR_out[20:16], mux2_out, reg_write, rst, clk,read_data1,read_data2);

  sign_ext SGN_EXT(IR_out[15:0], sgn_ext_out);

  shl2_32b SHL2_1 (sgn_ext_out,shl2_1_out);

  mux2to1_32b muxA (pc_out,areg_out,Asel,Alu_inA);

  mux4to1_32b muxB(breg_out,32'd4,sgn_ext_out,shl2_1_out,Bsel,Alu_inB);

  alu ALU(Alu_inA,Alu_inB,alu_ctrl,alu_out,zero);

  shl2 SHL2_2(IR_out[25:0], shl2_out);

  mux2to1_32b MUX_4(alu_reg_out, MDR_out, mem_to_reg, mux4_out);
  
  mux4to1_32b MUX_5(alu_out,{pc_out[31:28],shl2_out},alu_reg_out,areg_out,pc_src,pc_in);

  assign mem_write_data=breg_out;
  assign opcode=IR_out[31:26];
  assign func=IR_out[5:0];
  
endmodule

