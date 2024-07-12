module alu (
    input  [31:0] a, b,
    input  [2:0]  ALUControl,
    output reg [31:0] Result,
    output wire [3:0]  ALUFlags
);

    wire        neg, zero, carry, overflow;
    wire [31:0] condinvb;
    wire [32:0] sum;
    wire [31:0] mul_result;

    wire        sign_a, sign_b;
    wire [7:0]  exponent_a, exponent_b;
    reg [23:0] mantissa_a, mantissa_b;

    reg         sign_result;
    reg  [7:0]  exponent_result;
    reg  [24:0] mantissa_result;
    
    reg [47:0] mantissa_product;
    reg [7:0] exponent_temp;

    // Instanciar el módulo de multiplicación de punto flotante
    fp_mul mul (
        .a(a),
        .b(b),
        .result(mul_result)
    );

    assign sign_a = a[31];
    assign sign_b = b[31];
    assign exponent_a = a[30:23];
    assign exponent_b = b[30:23];
    
    integer add_exp_diff;

    assign condinvb = ALUControl[0] ? ~b : b;
    assign sum = a + condinvb + ALUControl[0];

    always @(*) begin
        mantissa_a = (exponent_a != 0) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
        mantissa_b = (exponent_b != 0) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
        add_exp_diff = exponent_a - exponent_b;

        exponent_result = (add_exp_diff > 0) ? exponent_a :
                          (add_exp_diff < 0) ? exponent_b :
                          exponent_a;

        mantissa_a = (add_exp_diff > 0) ? mantissa_a : mantissa_a >> (-add_exp_diff);
        mantissa_b = (add_exp_diff < 0) ? mantissa_b : mantissa_b >> add_exp_diff;

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

        if (mantissa_result[24]) begin
            mantissa_result = mantissa_result >> 1;
            exponent_result = exponent_result + 1;
        end

        // Imprimir valores intermedios para depuración
        $display("a = %h, b = %h, ALUControl = %b", a, b, ALUControl);
        $display("sign_a = %b, sign_b = %b", sign_a, sign_b);
        $display("exponent_a = %d, exponent_b = %d", exponent_a, exponent_b);
        $display("mantissa_a = %h, mantissa_b = %h", mantissa_a, mantissa_b);
        $display("mantissa_result = %h, exponent_result = %d", mantissa_result, exponent_result);
        $display("Ultimo para depurar");
    end

    always @(*) begin
        casex (ALUControl[2:0])
            3'b000: Result = sum;       // Suma
            3'b001: Result = sum;       // Resta
            3'b010: Result = a & b;     // AND
            3'b011: Result = a | b;     // OR
            3'b100: Result = {sign_result, exponent_result, mantissa_result[22:0]}; // Suma/resta de punto flotante
            3'b101: Result = mul_result; // Multiplicación de punto flotante
            default: Result = 32'b0;    // Caso por defecto
        endcase

        // Imprimir resultado final para depuración
        $display("Result = %h", Result);
    end

    assign neg      = Result[31];
    assign zero     = (Result == 32'b0);
    assign carry    = (ALUControl[1] == 1'b0) & sum[32];
    assign overflow = (ALUControl[1] == 1'b0) & ~(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ sum[31]);
    assign ALUFlags = {neg, zero, carry, overflow};
endmodule
