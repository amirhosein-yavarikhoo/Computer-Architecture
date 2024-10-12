module controller ( opcode, func, zero, reg_dst, mem_to_reg, reg_write, 
                    alu_src, mem_read, mem_write, pc_src, operation,
                    jctrl, jrctrl, jalctrl, wrdmux
                  );
                    
    input [5:0] opcode;
    input [5:0] func;
    input zero;
    output  reg_dst, mem_to_reg, reg_write, alu_src, 
            mem_read, mem_write, pc_src,
            jctrl, jrctrl, jalctrl,
            wrdmux;
    reg     reg_dst, mem_to_reg, reg_write, 
            alu_src, mem_read, mem_write,
            jctrl, jrctrl, jalctrl,
            wrdmux; 
    output [2:0] operation;
            
    reg [1:0] alu_op;     
    reg branch;   
    
    alu_controller ALU_CTRL(alu_op, func, operation);
    
    always @(opcode)
    begin
      {reg_dst, alu_src, mem_to_reg,
      reg_write, mem_read, mem_write,
      branch, alu_op, jctrl,
      jrctrl, jalctrl, wrdmux} = 13'd0;
      case (opcode)
        // RType instructions
        6'b000000 : {reg_dst, reg_write, alu_op} = 4'b1110;   
        // Load Word (lw) instruction           
        6'b100011 : {alu_src, mem_to_reg, reg_write, mem_read} = 4'b1111; 
        // Store Word (sw) instruction
        6'b101011 : {alu_src, mem_write} = 2'b11;                                 
        // Branch on equal (beq) instruction
        6'b000100 : {branch, alu_op} = 3'b101; 
        // Add immediate (addi) instruction
        6'b001001: {reg_write, alu_src} = 2'b11;
	// Set less than immediate (slti) instruction
	6'b001010: {alu_src, reg_write, alu_op} = 4'b1111;
	// Jump instruction
	6'b000010 : jctrl = 1'b1;  
	// Jump and link (jal) instructiom
	6'b000011 : {jalctrl, wrdmux, jctrl, reg_write} = 4'b1111;
	// Jump register (jr) instruction
	6'b000110: jrctrl = 1'b1;  
      endcase
    end
    
    assign pc_src = branch & zero;
  
endmodule

