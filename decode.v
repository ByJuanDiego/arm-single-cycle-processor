module decode (
	Op,
	Funct,
	Rd,
	FlagW,
	PCS,
	RegW,
	MemW,
	MemtoReg,
	ALUSrc,
	ImmSrc,
	RegSrc,
	ALUControl
);
	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	output reg [1:0] FlagW;
	output wire PCS;
	output wire RegW;
	output wire MemW;
	output wire MemtoReg;
	output wire ALUSrc;
	output wire VecW;
	output wire [1:0] ImmSrc;
	output wire [1:0] RegSrc;
	output reg [2:0] ALUControl;
	reg [10:0] controls;
	wire Branch;
	wire ALUOp;
	always @(*)
		casex (Op)
			2'b00:
				if (Funct[5])
					if (Funct[4:1] ==  4'b1001) //si esq cmd es de tipo vectoradd: 
						controls = 11'b10000101001;
					else
						controls = 11'b00000101001;
				else
					controls = 11'b00000001001;
			2'b01:
				if (Funct[0])
					controls = 11'b00001111000;
				else
					controls = 11'b01001110100;
			2'b10: controls = 11'b00110100010;
			default: controls = 11'bxxxxxxxxxxx;
		endcase
	assign {VecW, RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp} = controls;
	always @(*)
		if (ALUOp) begin
			case (Funct[4:1])
				4'b0100: ALUControl = 3'b000; //AddNormal 
				4'b0101: ALUControl = 3'b001;  
				4'b0010: ALUControl = 3'b010;
				4'b0000: ALUControl = 3'b011;
				4'b1100: ALUControl = 3'b100; //AddFloat
				4'b1001: ALUControl = 3'b101; //AddVector 
				default: ALUControl = 3'bxxx;
			endcase
			FlagW[1] = Funct[0];
			FlagW[0] = Funct[0] & ((ALUControl == 3'b000) | (ALUControl == 3'b010));
		end
		else begin
			ALUControl = 3'b000;
			FlagW = 2'b00;
		end
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule
