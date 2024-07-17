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

    // Output of the clk_divider
    wire led;

    // Instantiate the top module
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

    // Instantiate the clk_divider
    clk_divider clk_div_inst(
        .clk(clk),
        .rst(reset),
        .led(led)
    );

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, testbench);
    end

    initial begin
        reset <= 1;
        #(22);
        reset <= 0;
    end

    always begin
        clk <= 1;
        #(5);
        clk <= 0;
        #(5);
    end

    always @(negedge clk) begin
        if (MemWrite) begin
            if ((DataAdr === 100) & (WriteData === 7)) begin
                $display("Simulation succeeded");
                $stop;
            end else if (DataAdr !== 96) begin
                $display("Simulation failed");
                $stop;
            end
        end
    end

    // Monitor the led output from clk_divider
    initial begin
        $monitor("Time = %0t | led = %b", $time, led);
    end
endmodule
