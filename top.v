module top (
	clk,
	reset,
	WriteData,
	VecWriteData_0,
	VecWriteData_1,
	VecWriteData_2,
	VecWriteData_3,
	VecWriteData_4,
	DataAdr,
	MemWrite
);
	input wire clk;
	input wire reset;
	output wire [31:0] WriteData;
	output wire [31:0] VecWriteData_0;
	output wire [31:0] VecWriteData_1;
	output wire [31:0] VecWriteData_2;
	output wire [31:0] VecWriteData_3;
	output wire [31:0] VecWriteData_4;

	output wire [31:0] DataAdr;
	output wire MemWrite;
	wire [31:0] PC;
	wire [31:0] Instr;
	wire [31:0] ReadData;
	arm arm(
		.clk(clk),
		.reset(reset),
		.PC(PC),
		.Instr(Instr),
		.MemWrite(MemWrite),
		.ALUResult(DataAdr),
		.WriteData(WriteData),
		.VecWriteData_0(VecWriteData_0),
		.VecWriteData_1(VecWriteData_1),
		.VecWriteData_2(VecWriteData_2),
		.VecWriteData_3(VecWriteData_3),
		.VecWriteData_4(VecWriteData_4),
		.ReadData(ReadData)
	);
	imem imem(
		.a(PC),
		.rd(Instr)
	);
	dmem dmem(
		.clk(clk),
		.we(MemWrite),
		.a(DataAdr),
		.wd(WriteData),
		.rd(ReadData)
	);
endmodule
