module alu (
    input  [31:0] a, b,
    input  [2:0]  ALUControl,
    output reg [31:0] Result,
    output wire [3:0]  ALUFlags
);
	wire        neg, zero, carry, overflow;
    wire [31:0] condinvb;
    wire [32:0] sum;

    assign condinvb = ALUControl[0] ? ~b : b;
    assign sum = a + condinvb + ALUControl[0];

    wire [31:0] add_result;
    wire [31:0] mul_result;
    
    fp_add add (
        .a(a),
        .b(b),
        .result(add_result)
    );

    fp_mul mul (
        .a(a),
        .b(b),
        .result(mul_result)
    );

    always @(*)
    begin
        casex (ALUControl[2:0])
            3'b00?: Result = sum;        // ALUControl[1:0] = 00
            3'b010: Result = a & b;      // ALUControl[1:0] = 10
            3'b011: Result = a | b;      // ALUControl[1:0] = 11
            3'b111: Result = a ^ b;      // ALUControl[1:0] XOR
            3'b100: Result = add_result; // ALUControl[1:0] = 00
            3'b101: Result = mul_result;
            default: Result = 32'b0;     // Default case
        endcase
    end

    assign neg      = Result[31];
    assign zero     = (Result == 32'b0);
    assign carry    = (ALUControl[1] == 1'b0) & sum[32];
    assign overflow = (ALUControl[1] == 1'b0) & ~(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ sum[31]);
    assign ALUFlags = {neg, zero, carry, overflow};

endmodule
