module datapath (
	clk,
	reset,
	RegSrc,
	RegWrite,
	ImmSrc,
	ALUSrc,
	ALUControl,
	MemtoReg,
	PCSrc,
	ALUFlags,
	PC,
	Instr,
	ALUResult,
	WriteData,
	VecWriteData_0,
	VecWriteData_1,
	VecWriteData_2,
	VecWriteData_3,
	VecWriteData_4,
	VecWrite,
	ReadData
);
	input wire clk;
	input wire reset;
	input wire [1:0] RegSrc;
	input wire RegWrite;
	input wire [1:0] ImmSrc;
	input wire ALUSrc;
	input wire [3:0] ALUControl;
	input wire VecWrite;
	input wire MemtoReg;
	input wire PCSrc;
	output wire [3:0] ALUFlags;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	output wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	output wire [31:0] VecWriteData_0;
	output wire [31:0] VecWriteData_1;
	output wire [31:0] VecWriteData_2;
	output wire [31:0] VecWriteData_3;
	output wire [31:0] VecWriteData_4;

	input wire [31:0] ReadData;
	wire [31:0] PCNext;
	wire [31:0] PCPlus4;
	wire [31:0] PCPlus8;
	wire [31:0] ExtImm;
	wire [31:0] SrcA;
	wire [31:0] SrcB;
	wire [31:0] Result;
	wire [31:0] VecSrc_0;
	wire [31:0] VecSrc_1;
	wire [31:0] VecSrc_2;
	wire [31:0] VecSrc_3;
	wire [31:0] VecSrc_4;

	wire [3:0] RA1;
	wire [3:0] RA2;
	mux2 #(32) pcmux(
		.d0(PCPlus4),
		.d1(Result),
		.s(PCSrc),
		.y(PCNext)
	);
	flopr #(32) pcreg(
		.clk(clk),
		.reset(reset),
		.d(PCNext),
		.q(PC)
	);
	adder #(32) pcadd1(
		.a(PC),
		.b(32'b100),
		.y(PCPlus4)
	);
	adder #(32) pcadd2(
		.a(PCPlus4),
		.b(32'b100),
		.y(PCPlus8)
	);
	mux2 #(4) ra1mux(
		.d0(Instr[19:16]),
		.d1(4'b1111),
		.s(RegSrc[0]),
		.y(RA1)
	);
	mux2 #(4) ra2mux(
		.d0(Instr[3:0]),
		.d1(Instr[15:12]),
		.s(RegSrc[1]),
		.y(RA2)
	);
	regfile rf(
		.clk(clk),
		.we3(RegWrite),
		.ra1(RA1),
		.ra2(RA2),
		.wa3(Instr[15:12]),
		.wd3(Result),
		.r15(PCPlus8),
		.rd1(SrcA),
		.rd2(WriteData)
	);

	vector_regfile vrf(
		.clk(clk),
		.reset(reset),
		.we(VecWrite), // control - decoder 
		.va1(RA1),// direccion de vector de entrada
		.vd2(Instr[15:12]), // direccion del vector de destino 
		.wd2_0(VecWriteData_0),
		.wd2_1(VecWriteData_1),
		.wd2_2(VecWriteData_2),
		.wd2_3(VecWriteData_3),
		.wd2_4(VecWriteData_4),
		.vr2_0(VecSrc_0),
		.vr2_1(VecSrc_1),
		.vr2_2(VecSrc_2),
		.vr2_3(VecSrc_3),
		.vr2_4(VecSrc_4)
	);
	
	mux2 #(32) resmux(
		.d0(ALUResult),
		.d1(ReadData),
		.s(MemtoReg),
		.y(Result)
	);
	extend ext(
		.Instr(Instr[23:0]),
		.ImmSrc(ImmSrc),
		.ExtImm(ExtImm)
	);
	mux2 #(32) srcbmux(
		.d0(WriteData),
		.d1(ExtImm),
		.s(ALUSrc),
		.y(SrcB)
	);
	alu alu(
		SrcA,
		SrcB,
		ALUControl[2:0],
		ALUResult,
		ALUFlags
	);

	aluvector aluvec(
		.imm32(SrcB),
		.a_0(VecSrc_0), // Vector de entrada
		.a_1(VecSrc_1),
		.a_2(VecSrc_2), // Vector de entrada
		.a_3(VecSrc_3),
		.a_4(VecSrc_4), // Vector de entrada
		.ALUOp(ALUControl[2:0]),    // Señal de operación de la ALU (0: Suma, 1: Resta, 2: AND, 3: OR)
		.Result_0(VecWriteData_0),
		.Result_1(VecWriteData_1),
		.Result_2(VecWriteData_2),
		.Result_3(VecWriteData_3),
		.Result_4(VecWriteData_4)
	);

endmodule
