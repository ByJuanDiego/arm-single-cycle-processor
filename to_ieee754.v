module int_to_ieee754 (
    input wire [31:0] int_in,
    output reg [31:0] ieee_out
);
    reg [7:0] exponent;
    reg [22:0] mantissa;
    reg [4:0] shift_amount; // Shift amount ahora es de 5 bits para manejar los casos de desplazamiento correctos

    always @(*) begin
        if (int_in == 0) begin
            ieee_out = 32'b0; // El número 0 en IEEE 754
        end else begin
            shift_amount = $clog2(int_in);
            exponent = 127 + shift_amount;
            mantissa = (int_in << (23 - shift_amount)) & 23'h7FFFFF; // Normalización de la mantisa
            
            ieee_out[31] = 0; // Signo siempre es 0 para números positivos
            ieee_out[30:23] = exponent;
            ieee_out[22:0] = mantissa;
        end
    end
endmodule
