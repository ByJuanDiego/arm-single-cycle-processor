module fp_mul(
    input wire [31:0] int_A,
    input wire [31:0] int_B,
    output reg [31:0] out
);
    wire [31:0] A;
    wire [31:0] B;

    // Instanciar los módulos de conversión
    int_to_ieee754 conv_A (
        .int_in(int_A),
        .ieee_out(A)
    );

    int_to_ieee754 conv_B (
        .int_in(int_B),
        .ieee_out(B)
    );

    // Lógica de signos
    wire signA, signB, signOut;
    assign signA = A[31];
    assign signB = B[31];
    assign signOut = signA ^ signB;

    // Lógica de exponentes
    wire [7:0] expA, expB;
    reg [8:0] expSum;  // Cambiado a reg para usar en always block
    reg [7:0] expOut;
    assign expA = A[30:23];
    assign expB = B[30:23];

    // Lógica de mantissas 
    wire [22:0] mantA, mantB;
    reg [22:0] mantOut;
    assign mantA = A[22:0];
    assign mantB = B[22:0];

    wire [23:0] completeMantA = {1'b1, mantA};
    wire [23:0] completeMantB = {1'b1, mantB};

    // Multiplicación de mantisas
    wire [47:0] multiplication;
    assign multiplication = completeMantA * completeMantB;

    // Normalización del producto
    always @(*) begin
        expSum = expA + expB - 8'd127;  // Inicialización del sumatorio de exponentes
        if (multiplication[47]) begin
            mantOut = multiplication[46:24]; // Mantisa normalizada
            expOut = expSum[7:0] + 1; // Ajustar el exponente si hay carry en la mantisa
        end else begin
            mantOut = multiplication[45:23];
            expOut = expSum[7:0];
        end
    end

    // Construcción del resultado final
    always @(*) begin
        if (expOut < 0 || expOut >= 255) begin
            out = 32'b0; // Underflow o overflow
        end else begin
            out = {signOut, expOut, mantOut};
        end
    end

    // Debug
    always @(*) begin
        $display("A = %h, B = %h, out = %h", A, B, out);
        $display("signA = %b, signB = %b, signOut = %b", signA, signB, signOut);
        $display("expA = %d, expB = %d, expSum = %d, expOut = %d", expA, expB, expSum, expOut);
        $display("mantA = %h, mantB = %h", mantA, mantB);
        $display("completeMantA = %h, completeMantB = %h", completeMantA, completeMantB);
        $display("multiplication = %h", multiplication);
        $display("mantOut = %h", mantOut);
    end

endmodule