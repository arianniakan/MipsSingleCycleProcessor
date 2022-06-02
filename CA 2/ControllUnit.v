module ControllUnit  (input [5:0] opc, func, input clk, rst, output reg Branch, jump, jr, RegDst, R31, WriteSrc, Regwrite, ALUsrc, MemRead, MemWrite, MemtoReg, output [2:0] ALUcontrol);
                    
 
    reg [1:0] alu_op;     
    alu_cu ALU_CU(alu_op, func, ALUcontrol);
    
    always @(opc)
    begin
      {Branch, jump, jr, RegDst, R31, WriteSrc, Regwrite, ALUsrc, MemRead, MemWrite, MemtoReg} = 11'd0;
      case (opc)
        6'b000000 : {RegDst, Regwrite, alu_op} = 4'b1110;           		    // RType 

        6'b001000: {ALUsrc, Regwrite,alu_op} = 4'b1100;   		 				// addi
		
        6'b001010: {ALUsrc,Regwrite,alu_op} = 4'b1111;						    // slti

        6'b100011 : {ALUsrc, MemRead, MemtoReg, Regwrite,alu_op} = 6'b111100;   // lw          

        6'b101011 : {ALUsrc, MemWrite, alu_op} = 4'b1100;                       // sw
    
        6'b000010 : {jump} = 1'b1;        						                // Jump

        6'b010000: {jr} = 1'b1;         									    // Jump R 

        6'b000011: {R31, WriteSrc, jump, Regwrite} = 4'b1111;					// Jump And link

        6'b000100: {Branch,alu_op} = 3'b101;     				                // beq

      endcase
    end
    

  
endmodule