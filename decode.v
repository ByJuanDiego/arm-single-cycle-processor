module decode (
	Op,
	Funct,
	Rd,
	FlagW,
	PCS,
	RegW,
	MemW,
	VecW,
	VecIdxW,
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
	output wire VecIdxW;
	output wire [1:0] ImmSrc;
	output wire [1:0] RegSrc;
	output reg [3:0] ALUControl;
	reg [11:0] controls;
	wire Branch;
	wire ALUOp;
	always @(*)
		casex (Op)
			2'b00:
				if (Funct[5])
					if (Funct[4:1] == 4'b1101)	   // MOVIDX Vec
						controls =     12'b100011000001;
					else
						if (Funct[4:1] == 4'b1110) // MOV a reg
							controls = 12'b000011101001;
					else
						if (Funct[4]) //si es que es de tipo Vec con imm 
							controls = 12'b010000100001;
						else		
							controls = 12'b000000101001;
				else
					if (Funct[4]) //si es que es de tipo Vec con vec
							controls = 12'b010000000001;
					else
						controls = 12'b000000001001;
			2'b01:
				if (Funct[0])
					controls = 12'b000001111000;
				else
					controls = 12'b001001110100;
			2'b10: controls = 12'b000110100010;
			default: controls = 12'bxxxxxxxxxxxx;
		endcase
	assign {VecIdxW, VecW, RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp} = controls;
	always @(*)
		if (ALUOp) begin
			case (Funct[4:1])
				4'b1110: ALUControl = 4'b0000; // MOV
				4'b1101: ALUControl = 4'bXXXX; // MOV IDX VEC
				// Integer number control
				4'b0100: ALUControl = 4'b0000; // ADD
				4'b0101: ALUControl = 4'b0001; // SUB
				4'b0010: ALUControl = 4'b0010; // AND
				4'b0000: ALUControl = 4'b0011; // ORR
				4'b0011: ALUControl = 4'b0111; // XOR
				// Floating point control
				4'b0111: ALUControl = 4'b1100; // FADD
				4'b0110: ALUControl = 4'b0101; // FMUL
				// Vector control
				4'b1000: ALUControl = 4'b1000; // VADD
				4'b1100: ALUControl = 4'b1100; // VADDFP
				4'b1001: ALUControl = 4'b1001; // VSUB
				4'b1010: ALUControl = 4'b1010; // VAND
				4'b1011: ALUControl = 4'b1011; // VORR
				4'b1111: ALUControl = 4'b1111; // VXOR
				default: ALUControl = 4'bxxxx;
			endcase
			FlagW[1] = Funct[0];
			FlagW[0] = Funct[0] & ((ALUControl == 4'b0000) | (ALUControl == 4'b0001));
		end
		else begin
			ALUControl = 4'b0000;
			FlagW = 2'b00;
		end
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule
