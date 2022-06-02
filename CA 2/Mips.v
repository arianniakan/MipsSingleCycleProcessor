module MIPS(input clk, rst);
wire Branch, jump, jr, RegDst, R31, WriteSrc, Regwrite, ALUsrc, MemRead, MemWrite, MemtoReg;
wire [2:0] ALUcontrol;
wire [5:0]opc,func;

DataPath dp (clk, rst, Branch, jump, jr, RegDst, R31, WriteSrc, Regwrite, ALUsrc, MemRead, MemWrite, MemtoReg, ALUcontrol, opc, func);

ControllUnit cu (opc, func, clk, rst, Branch, jump, jr, RegDst, R31, WriteSrc, Regwrite, ALUsrc, MemRead, MemWrite, MemtoReg, ALUcontrol);

endmodule