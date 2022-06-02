module DataPath(input clk, rst, Branch, jump, jr, RegDst, R31, WriteSrc, Regwrite, ALUsrc, MemRead, MemWrite, MemtoReg, input[2:0] ALUcontrol, output[5:0] opc, func);

reg [31:0] PC=32'b0;
wire [31:0] nPC;
wire [31:0] PCp4;
wire [31:0] PCb;
wire [31:0] instruction;

wire [27:0] Inst28;
wire [27:0] Adr28;

wire [4:0]regread1,regread2,WriteReg;
wire [31:0]regWriteData, regReadData1, regReadData2;

wire [31:0] aluinb;
wire [31:0] aluout;
wire [31:0] seInst;
wire [31:0] seInstsl2;
wire zerof;

wire [31:0] MemReadData;
always @(posedge clk) begin
    if(rst) PC<=32'b0;
    else PC<=nPC;
end
InstMem inst_mem (clk, PC, instruction);
RegisterFile register_file (clk, rst, Regwrite, regread1, regread2, WriteReg, regWriteData, regReadData1, regReadData2);
ALU alu (regReadData1, aluinb, ALUcontrol, zerof, aluout);
SE16to32 se1 (instruction[15:0], seInst);
SE26to28 se2 (instruction[25:0], Inst28);

DataMem data_mem (clk, MemRead, MemWrite, aluout, regReadData2, MemReadData);

adder a1 (32'd4, PC, PCp4);
adder a2 (PCp4, seInstsl2,PCb);

shl2_32 shl1(seInst,seInstsl2);

shl2_28 shl2(Inst28, Adr28);

//assign statements of RegFile
assign regread1 = instruction[25:21];
assign regread2 = instruction[20:16];
assign WriteReg = R31?5'd31:
                  RegDst? instruction[15:11]:instruction[20:16];
assign regWriteData = WriteSrc?PCp4:
                   MemtoReg?MemReadData:aluout;
//assign statements of Alu
assign aluinb = ALUsrc?seInst:regReadData2;

//assign statments of next PC
assign nPC = jr?regReadData1:
             jump? {PCp4[31:28],Adr28}:
             (Branch&zerof)? PCb:PCp4;
        
assign opc = instruction[31:26];
assign func = instruction[5:0];
endmodule