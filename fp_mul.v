module fp_mul (
    input  [31:0] a, b,
    output reg [31:0] result
);
    wire sign_a, sign_b, sign_result;
    wire [7:0] exponent_a, exponent_b;
    wire [23:0] mantissa_a, mantissa_b;
    reg [47:0] mantissa_product;
    reg [22:0] mantissa_final;
    reg [7:0] exponent_temp;
    reg [7:0] exponent_result;

    assign sign_a = a[31];
    assign sign_b = b[31];
    assign exponent_a = a[30:23];
    assign exponent_b = b[30:23];
    assign mantissa_a = (exponent_a == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    assign mantissa_b = (exponent_b == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
    
    assign sign_result = sign_a ^ sign_b;
    reg [7:0] exp_a, exp_b;

    always @(*) begin
        // Sumar el sesgo (bias) al exponente de los operandos
        exp_a = (exponent_a == 0) ? 8'd0 : exponent_a - 8'd127;
        exp_b = (exponent_b == 0) ? 8'd0 : exponent_b - 8'd127;

        // Multiplicar las mantissas
        mantissa_product = mantissa_a * mantissa_b;
        
        // Ajustar el exponente
        exponent_temp = exp_a + exp_b + 8'd127;
        
        // Normalización
        if (mantissa_product[47]) begin
            mantissa_final = mantissa_product[46:24];
            exponent_temp = exponent_temp + 1;
        end else begin
            mantissa_final = mantissa_product[45:23];
        end
        
        // Verificar si el resultado es subnormal
        if (mantissa_final == 0) begin
            exponent_result = 0;
        end else if (exponent_temp <= 0) begin
            // Manejo de subnormales
            mantissa_final = mantissa_final >> (1 - exponent_temp);
            exponent_result = 0;
        end else begin
            exponent_result = exponent_temp;
        end

        // Empaquetar el resultado
        result = {sign_result, exponent_result, mantissa_final};

        // Imprimir valores intermedios para depuración
        $display("a = %h, b = %h", a, b);
        $display("sign_a = %b, sign_b = %b, sign_result = %b", sign_a, sign_b, sign_result);
        $display("exponent_a = %d, exponent_b = %d, exponent_result = %d", exponent_a, exponent_b, exponent_result);
        $display("mantissa_a = %h, mantissa_b = %h", mantissa_a, mantissa_b);
        $display("mantissa_product = %h", mantissa_product);
        $display("mantissa_final = %h, exponent_temp = %d", mantissa_final, exponent_temp);
        $display("result = %h", result);
    end
endmodule
