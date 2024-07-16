module fp_add (
    input  [31:0] a, b,
    output reg [31:0] result,
    output reg neg, zero, carry, overflow
);

    // Descomponemos la entrada "a" en signo, exponente y mantisa
    wire        sign_a;
    wire [7:0]  exponent_a;
    reg [23:0]  mantissa_a;

    // Descomponemos la entrada "b" en signo, exponente y mantisa
    wire        sign_b;
    wire [7:0]  exponent_b;
    reg [23:0]  mantissa_b;

    // Descomponemos los valores de la salida "result"
    reg         sign_result;     //  1 bit para el signo del resultado final
    reg  [24:0] mantissa_result; // 23 bits de la mantisa final, y 1 bit adicional por si hay carry en la suma de mantisas
    reg  [8:0]  exponent_result; //  8 bits del exponente final, y 1 bit adicional por si hay carry en el exponente final


    // Asignamos el signo y exponente de "a"
    assign sign_a = a[31];
    assign exponent_a = a[30:23];

    // Asignamos el signo y exponente de "b"
    assign sign_b = b[31];
    assign exponent_b = b[30:23];
    
    // Este valor corresponde a la diferencia de exponentes de "a" y "b".
    // Sirve para determinar cuantos bits tenemos que shiftear "a" o "b" para normalizar su mantisa. 
    integer add_exp_diff;

    always @(*)
    begin
        // Asignamos la mantisa de "a"
        mantissa_a = {1'b1, a[22:0]};

        // Asignamos la mantisa de "b"
        mantissa_b = {1'b1, b[22:0]};
        
        // Calculamos la diferencia de exponentes
        add_exp_diff = exponent_a - exponent_b;

        // Calculamos el exponente del resultado final (se toma el mayor exponente)
        exponent_result = (add_exp_diff > 0) ? exponent_a :
                          (add_exp_diff < 0) ? exponent_b :
                          exponent_a;

        // Si la diferencia de exponentes es 0, ni "a" ni "b" se shiftea
        // Si es mayor a 0, significa que exp(a) > exp(b), por lo que la mantisa de "b" se shiftea
        // Si es menor a 0, significa que exp(a) < exp(b), por lo que la mantisa de "a" se shiftea
        mantissa_a = (add_exp_diff <= 0)? mantissa_a >> (-add_exp_diff): mantissa_a;
        mantissa_b = (add_exp_diff >  0)? mantissa_b >>   add_exp_diff : mantissa_b;

        // Calculamos la mantisa resultante.
        //     Si ambos signos son iguales, solo sumamos las mantisas
        //     Si sign(a) es positivo y sign(b) es negativo, tenemos 2 casos
        //         Si mantisa(a) >= mantisa(b), entonces la mantisa resultante sera mantisa_a - mantisa_b
        //         Si mantisa(b) >  mantisa(a), entonces la mantisa resultante sera mantisa_b - mantisa_a
        //     Aplicamos la misma logica si sign(a) es negativo y sign(b) es positivo
        // Finalmente, lo que obtenemos es el valor absoluto de la suma de ambas mantisas.
        mantissa_result = (sign_a == sign_b) ? mantissa_a + mantissa_b :
                          (sign_a == 1'b0 && mantissa_a >= mantissa_b) ? mantissa_a - mantissa_b :
                          (sign_a == 1'b0 && mantissa_a < mantissa_b)  ? mantissa_b - mantissa_a :
                          (sign_a == 1'b1 && mantissa_b >= mantissa_a) ? mantissa_b - mantissa_a :
                          (sign_a == 1'b1 && mantissa_b < mantissa_a)  ? mantissa_a - mantissa_b :
                          mantissa_a - mantissa_b;

        // Aqui se maneja la logica para determinar el signo del resultado final.
        sign_result = (sign_a == sign_b) ? sign_a :
                      (sign_a == 1'b0) ? (mantissa_a >= mantissa_b ? sign_a : sign_b) :
                      (sign_a == 1'b1) ? (mantissa_b >= mantissa_a ? sign_b : sign_a) :
                      sign_a;

        // Calculamos los flags
        neg = sign_result;
        carry = (add_exp_diff != 0 && mantissa_result[24]) | (add_exp_diff == 0 && mantissa_result[23]);
        overflow = 0;
        // Si hay un carry, shifteamos el resultado
        if ((add_exp_diff != 0 && mantissa_result[24]) | (add_exp_diff == 0 && mantissa_result[23]))
        begin
            mantissa_result = mantissa_result >> 1;
            exponent_result = exponent_result + 1;

            // Si al sumarle 1 al exponente se genera un carry en el exponente, seteamos el flag de carry a 1.
            if (exponent_result[8])
            begin
                carry = 1;
            end
        end
        zero = mantissa_result[22:0] == 23'b0;
        // Asignamos el resultado final de la suma
        result = {sign_result, exponent_result[7:0], mantissa_result[22:0]};
    end

endmodule
