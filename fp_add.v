module fp_add (
    input  [31:0] a, b,
    output reg [31:0] result,
    output reg neg, zero, carry, overflow
);

    // Descomponer la entrada "a" en signo, exponente y mantisa
    wire        sign_a;
    wire [7:0]  exponent_a;
    reg [23:0]  mantissa_a;

    // Descomponer la entrada "b" en signo, exponente y mantisa
    wire        sign_b;
    wire [7:0]  exponent_b;
    reg [23:0]  mantissa_b;

    // Descomponer el resultado en signo, exponente y mantisa
    reg         sign_result;     // 1 bit para el signo del resultado final
    reg  [24:0] mantissa_result; // 23 bits de la mantisa final, y 1 bit adicional para el acarreo en la suma de mantisas
    reg  [8:0]  exponent_result; // 8 bits del exponente final, y 1 bit adicional para el acarreo en el exponente final

    // Asignar signo y exponente de "a"
    assign sign_a = a[31];
    assign exponent_a = a[30:23];

    // Asignar signo y exponente de "b"
    assign sign_b = b[31];
    assign exponent_b = b[30:23];
    
    // Este valor corresponde a la diferencia de exponentes de "a" y "b".
    // Se utiliza para determinar cuántos bits desplazar "a" o "b" para normalizar sus mantisas.
    integer add_exp_diff;

    always @(*)
    begin
        // Asignar mantisa de "a"
        mantissa_a = {1'b1, a[22:0]};

        // Asignar mantisa de "b"
        mantissa_b = {1'b1, b[22:0]};
        
        // Calcular la diferencia de exponentes
        add_exp_diff = exponent_a - exponent_b;

        // Desplazar mantisas para alinear exponentes
        if (add_exp_diff > 0) begin
            mantissa_b = mantissa_b >> add_exp_diff;
            exponent_result = exponent_a;
        end else if (add_exp_diff < 0) begin
            mantissa_a = mantissa_a >> (-add_exp_diff);
            exponent_result = exponent_b;
        end else begin
            exponent_result = exponent_a;
        end

        // Calcular la mantisa resultante
        if (sign_a == sign_b) begin
            mantissa_result = mantissa_a + mantissa_b;
            sign_result = sign_a;
        end else if (mantissa_a >= mantissa_b) begin
            mantissa_result = mantissa_a - mantissa_b;
            sign_result = sign_a;
        end else begin
            mantissa_result = mantissa_b - mantissa_a;
            sign_result = sign_b;
        end

        // Normalizar el resultado
        if (mantissa_result[24]) begin
            mantissa_result = mantissa_result >> 1;
            exponent_result = exponent_result + 1;
        end else begin
            while (mantissa_result[23] == 0 && exponent_result > 0) begin
                mantissa_result = mantissa_result << 1;
                exponent_result = exponent_result - 1;
            end
        end

        // Setear flags
        neg = sign_result;
        zero = (mantissa_result == 0);
        carry = 0;
        overflow = (exponent_result >= 255);

        // Asignar el resultado final
        result = {sign_result, exponent_result[7:0], mantissa_result[22:0]};
    end

endmodule
