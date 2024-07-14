module alu (
    input  [31:0] a, b,
    input  [2:0]  ALUControl,
    output reg [31:0] Result,
    output wire [3:0]  ALUFlags
);

	wire        neg, zero, carry, overflow;
    wire [31:0] condinvb;
    wire [32:0] sum;

    wire        sign_a, sign_b;
    wire [7:0]  exponent_a, exponent_b;
    reg [23:0] mantissa_a, mantissa_b;

    reg         sign_result;
    reg  [7:0]  exponent_result;
    reg  [24:0] mantissa_result;

    assign sign_a = a[31];
    assign sign_b = b[31];
    assign exponent_a = a[30:23];
    assign exponent_b = b[30:23];
    
    integer add_exp_diff;

    assign condinvb = ALUControl[0] ? ~b : b;

    assign sum = a + condinvb + ALUControl[0];

    always @(*)
    begin
        mantissa_a = {1'b1, a[22:0]};
        mantissa_b = {1'b1, b[22:0]};
        add_exp_diff = exponent_a - exponent_b;

        exponent_result = (add_exp_diff > 0) ? exponent_a :
                          (add_exp_diff < 0) ? exponent_b :
                          exponent_a;

        mantissa_a = (exponent_result <= 0)? mantissa_a >> (-add_exp_diff): mantissa_a;
        mantissa_b = (exponent_result > 0)? mantissa_b >> add_exp_diff : mantissa_b;

        mantissa_result = (sign_a == sign_b) ? mantissa_a + mantissa_b :
                          (sign_a == 1'b0 && mantissa_a >= mantissa_b) ? mantissa_a - mantissa_b :
                          (sign_a == 1'b0 && mantissa_a < mantissa_b)  ? mantissa_b - mantissa_a :
                          (sign_a == 1'b1 && mantissa_b >= mantissa_a) ? mantissa_b - mantissa_a :
                          (sign_a == 1'b1 && mantissa_b < mantissa_a)  ? mantissa_a - mantissa_b :
                          mantissa_a - mantissa_b;
                          
        sign_result = (sign_a == sign_b) ? sign_a :
                      (sign_a == 1'b0) ? (mantissa_a >= mantissa_b ? sign_a : sign_b) :
                      (sign_a == 1'b1) ? (mantissa_b >= mantissa_a ? sign_b : sign_a) :
                      sign_a;

        if (mantissa_result[24])
        begin
            mantissa_result = mantissa_result >> 1;
            exponent_result = exponent_result + 1;
        end
    end

    always @(*)
    begin
        casex (ALUControl[2:0])
            3'b00?: Result = sum;                                                   // ALUControl[1:0] = 00
            3'b010: Result = a & b;                                                 // ALUControl[1:0] = 10
            3'b011: Result = a | b;                                                 // ALUControl[1:0] = 11
            3'b100: Result = {sign_result, exponent_result, mantissa_result[22:0]}; // ALUControl[1:0] = 00
            default: Result = 32'b0;                                                // Default case
        endcase
    end

    assign neg      = Result[31];
    assign zero     = (Result == 32'b0);
    assign carry    = (ALUControl[1] == 1'b0) & sum[32];
    assign overflow = (ALUControl[1] == 1'b0) & ~(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ sum[31]);
    assign ALUFlags = {neg, zero, carry, overflow};
endmodule
