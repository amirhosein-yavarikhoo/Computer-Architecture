module controller (clk,rst,reg_dst, mem_to_reg, reg_write,Mem_or_I,wr31,wrdmux,pc_src,PCWrite,
		   PCWriteCond,ld_IR,Bsel,Asel,mr,mw,opcode,func,operation);
   parameter [3:0] IF=4'd0,ID=4'd1,JC=4'd2,BC=4'd3,rte=4'd4,rtc=4'd5,mac=4'd6,swc=4'd7,ma=4'd8,lwc=4'd9,addiex=4'd10,addic=4'd11,sltiex=4'd12,sltic=4'd13,jalc=4'd14,jrc=4'd15;
   reg [3:0] pstate,nstate;
   output reg reg_dst, mem_to_reg, reg_write,Mem_or_I,wr31,wrdmux,mr,mw;
   input clk,rst;
   output reg [1:0] pc_src;
   output [2:0] operation;
   input [5:0] opcode,func;
   output reg PCWrite, PCWriteCond;
   output reg ld_IR;
   output reg [1:0] Bsel;
   output reg Asel;
   reg [1:0] alu_op;
   alu_controller ALU_CTRL(alu_op,func,operation);
   always @(posedge clk) begin
   	if (rst==1) pstate<=IF;
	else pstate<=nstate;
	end
   always @(pstate) begin
	{reg_dst, mem_to_reg, reg_write,Mem_or_I,wr31,wrdmux,mr,mw,PCWrite, PCWriteCond,ld_IR,Asel,pc_src,Bsel,alu_op}=18'd0;
	case (pstate)
		IF:begin
			Mem_or_I=1'b0;
			mr=1'b1;
			ld_IR=1'b1;
			Asel=1'b0;
			Bsel=2'b01;
			alu_op=2'b00;
			pc_src=2'b00;
			PCWrite=1'b1;
			nstate<=ID;
		end
		ID:begin
			Asel=1'b0;
			Bsel=2'b11;
			alu_op=2'b00;
			if (opcode==6'b100011|opcode==6'b101011) nstate<=mac; //lw or sw mac=memory address computation
			else if (opcode==6'b000000) nstate<=rte; //Rtype execution
			else if (opcode==6'b000100) nstate<=BC; //branch completion
			else if (opcode==6'b000010) nstate<=JC; //jump completion
			else if (opcode==6'b001001) nstate<=addiex; //addi execution
			else if (opcode==6'b000011) nstate<=jalc; //jal completion		
			else if (opcode==6'b000110) nstate<=jrc; //jump register completion
			else if (opcode==6'b001010) nstate<=sltiex; //slti execution
		end
		JC: begin
			pc_src=2'b01;
			PCWrite=1'b1;
			nstate<=IF;
		end
		BC: begin
			Asel=1'b1;
			Bsel=2'b00;
			alu_op=2'b01;
			PCWriteCond=1'b1;
			pc_src=2'b10;
			nstate<=IF;
		end
		rte: begin
			Asel=1'b1;
			Bsel=2'b00;
			alu_op=2'b10;
			nstate<=rtc; //Rtype completion
		end
		rtc: begin
			reg_dst=1'b1;
			reg_write=1'b1;
			wr31=1'b0;
			mem_to_reg=1'b0;
			wrdmux=1'b0;
			nstate<=IF;
		end
		mac: begin
			Asel=1'b1;
			Bsel=2'b10;
			alu_op=2'b00;
			if (opcode==6'b101011) nstate<=swc; //sw completion
			else if (opcode==6'b100011) nstate<=ma; //memory access
		end
		swc: begin
			mw=1'b1;
			Mem_or_I=1'b1;
			nstate<=IF;
		end
		ma: begin
			mr=1'b1;
			Mem_or_I=1'b1;
			nstate<=lwc; //lw completion
		end
		lwc: begin
			reg_dst=1'b0;
			wr31=1'b0;
			reg_write=1'b1;
			mem_to_reg=1'b1;
			wrdmux=1'b0;
			nstate<=IF;
		end
		addiex: begin
			Asel=1'b1;
			Bsel=2'b10;
			alu_op=2'b00;
			nstate<=addic; //addi completion
		end
		addic: begin
			reg_dst=1'b0;
			wr31=1'b0;
			mem_to_reg=1'b0;
			reg_write=1'b1;
			wrdmux=1'b0;
			nstate<=IF;
		end
		sltiex: begin
			Asel=1'b1;
			Bsel=2'b10;
			alu_op=2'b11;
			nstate<=sltic; //slti completion
		end
		sltic: begin
			reg_dst=1'b0;
			wr31=1'b0;
			mem_to_reg=1'b0;
			wrdmux=1'b0;
			reg_write=1'b1;
			nstate<=IF;
		end
		jalc: begin
			wrdmux=1'b1;
			wr31=1'b1;
			pc_src=2'b01;
			reg_write=1'b1;
			PCWrite=1'b1;
			nstate<=IF;
		end
		jrc: begin
			pc_src=2'b11;
			PCWrite=1'b1;
			nstate<=IF;
		end
		default: nstate<=IF;
		endcase
	end
			
		
			
endmodule
