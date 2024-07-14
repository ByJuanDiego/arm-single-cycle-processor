module testbench;
	reg clk;
	reg reset;
	wire [31:0] WriteData;
	wire [31:0] VecWriteData_0;
	wire [31:0] VecWriteData_1;
	wire [31:0] VecWriteData_2;
	wire [31:0] VecWriteData_3;
	wire [31:0] VecWriteData_4;

	wire [31:0] DataAdr;
	wire MemWrite;
	top dut(
		.clk(clk),
		.reset(reset),
		.WriteData(WriteData),
		.VecWriteData_0(VecWriteData_0),
		.VecWriteData_1(VecWriteData_1),
		.VecWriteData_2(VecWriteData_2),
		.VecWriteData_3(VecWriteData_3),
		.VecWriteData_4(VecWriteData_4),
		.DataAdr(DataAdr),
		.MemWrite(MemWrite)
	);
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, testbench);
    end
	initial begin
		reset <= 1;
		#(22)
			;
		reset <= 0;
	end
	always begin
		clk <= 1;
		#(5)
			;
		clk <= 0;
		#(5)
			;
	end
	always @(negedge clk)
		if (MemWrite)
			if ((DataAdr === 100) & (WriteData === 7)) begin
				$display("Simulation succeeded");
				$stop;
			end
			else if (DataAdr !== 96) begin
				$display("Simulation failed");
				$stop;
			end
endmodule
