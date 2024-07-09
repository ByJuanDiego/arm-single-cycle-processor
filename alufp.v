module alufp(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [1:0]  ALUControl,
    output reg  [31:0] Result,
    output reg  [3:0]  ALUFlags
);

    // ALU Flags
	wire        neg, zero, carry, overflow;
    // IEEE-754 components of inputs a and b
    wire        sign_a, sign_b;
    wire [7:0]  exponent_a, exponent_b;
    wire [23:0] mantissa_a, mantissa_b;

    // RESULTADO: 
    reg         sign_result;
    reg  [7:0]  exponent_result;
    reg  [24:0] mantissa_result; // Need an extra bit for rounding

    // Descomposicion de cada numero: 
    assign sign_a = a[31];
    assign exponent_a = a[30:23];
    assign mantissa_a = {1'b1, a[22:0]}; // Append implied leading '1'

    assign sign_b = b[31];
    assign exponent_b = b[30:23];
    assign mantissa_b = {1'b1, b[22:0]}; // Append implied leading '1'

    // Implement ALU operation (Addition of two floating-point numbers)
    always @(*)
    begin
        // SUM
        if (ALUControl == 2'b00) begin
            // Calcular diferencias de exponentes
            integer add_exp_diff;

            add_exp_diff = exponent_a - exponent_b;

            // Esta parte corresponde a shiftear el operando para que pueda efectuarse 
            // la suma correctamente
            // e.g.
            // a = 2_(10)
            // b = 1_(10)

            //     a       +       b     =
            // 1.0 * 2^1   +   1.0 * 2^0 =
            // 1.0 * 2^1   +   0.1 * 2^1
            // exponent_result = 1

            if (add_exp_diff > 0) // exponente a es mayor, b tiene que ser shifted
                begin
                    // Shift mantissa_b right to align with mantissa_a
                    mantissa_b = mantissa_b >> add_exp_diff; // >> es LSR
                    
                    exponent_result = exponent_a; // este es fijo 
                end 
            else if (add_exp_diff < 0) 
                begin
                    // Shift mantissa_a right to align with mantissa_b
                    mantissa_a = mantissa_a >> (-add_exp_diff);
                    exponent_result = exponent_b;
                end 
            else 
                begin
                    // Exponents are equal
                    exponent_result = exponent_a;
                end

            // Suma de mantisa
            if (sign_a == sign_b) 
                begin    
                    mantissa_result = mantissa_a + mantissa_b;
                    sign_result = sign_a;
                end 
            else 
                begin
                 if (sign_a == 1'b0) // Si a es positivo y b negativo
                    begin
                        if(mantissa_b > mantissa_a)
                        begin
                            mantissa_result = mantissa_b - mantissa_a;
                            sign_result = sign_b
                            end
                        else if(mantissa_a >= mantissa_b)
                        begin
                            mantissa_result = mantissa_a - mantissa_b;
                            sign_result = sign_a
                            end
                    end 
                    else if (sign_a == 1'b1) // Si b es positivo y a negativo
                    begin
                        if(mantissa_b >= mantissa_a)
                        begin
                            mantissa_result = mantissa_b - mantissa_a;
                            sign_result = sign_b
                            end
                        else if(mantissa_a > mantissa_b)
                        begin
                            mantissa_result = mantissa_a - mantissa_b;
                            sign_result = sign_a
                            end
                    end 
                end
                
            carry = mantissa_result[24];

            // Normalize mantissa_result
            if (mantissa_result[24])
            begin
                // Mantissa overflow, shift right and adjust exponent
                mantissa_result = mantissa_result >> 1;
                exponent_result = exponent_result + 1;
                
            end

            neg = sign_result;
            zero = (mantissa_result == 25'b0000000000000000000000000 && exponent_result == 8'b00000000);            
            overflow = (sign_a == 1 && sign_b == 1 && sign_result == 0) | (sign_a == 0 && sign_b == 0 && sign_result == 1);
        end
    end

    // Assemble result back into IEEE-754 format
    assign Result = {sign_result, exponent_result, mantissa_result[22:0]};
    assign ALUFlags = {neg, zero, carry, overflow};

endmodule
