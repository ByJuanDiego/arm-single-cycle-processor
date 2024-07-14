module arm (
	clk,
	reset,
	PC,
	Instr,
	MemWrite,
	ALUResult,
	WriteData,
	VecWriteData_0,
	VecWriteData_1,
	VecWriteData_2,
	VecWriteData_3,
	VecWriteData_4,
	ReadData
);
	input wire clk;
	input wire reset;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	output wire MemWrite;
	output wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	output wire [31:0] VecWriteData_0;
	output wire [31:0] VecWriteData_1;
	output wire [31:0] VecWriteData_2;
	output wire [31:0] VecWriteData_3;
	output wire [31:0] VecWriteData_4;

	input wire [31:0] ReadData;
	wire [3:0] ALUFlags;
	wire RegWrite;
	wire VecWrite;
	wire ALUSrc;
	wire MemtoReg;
	wire PCSrc;
	wire [1:0] RegSrc;
	wire [1:0] ImmSrc;
	wire [3:0] ALUControl;
	controller c(
		.clk(clk),
		.reset(reset),
		.Instr(Instr[31:12]),
		.ALUFlags(ALUFlags),
		.RegSrc(RegSrc),
		.RegWrite(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.ALUControl(ALUControl),
		.MemWrite(MemWrite),
		.MemtoReg(MemtoReg),
		.PCSrc(PCSrc),
		.VecWrite(VecWrite)
	);
	datapath dp(
		.clk(clk),
		.reset(reset),
		.RegSrc(RegSrc),
		.RegWrite(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.ALUControl(ALUControl),
		.MemtoReg(MemtoReg),
		.PCSrc(PCSrc),
		.ALUFlags(ALUFlags),
		.PC(PC),
		.Instr(Instr),
		.ALUResult(ALUResult),
		.WriteData(WriteData),
		.VecWriteData_0(VecWriteData_0),
		.VecWriteData_1(VecWriteData_1),
		.VecWriteData_2(VecWriteData_2),
		.VecWriteData_3(VecWriteData_3),
		.VecWriteData_4(VecWriteData_4),
		.VecWrite(VecWrite),
		.ReadData(ReadData)
	);
endmodule
