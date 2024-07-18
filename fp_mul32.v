module fp_mul32(
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] result
);

    // Lógica de signos
    wire signA, signB, signOut;
    assign signA = a[31];
    assign signB = b[31];
    assign signOut = signA ^ signB;

    // Lógica de exponentes
    wire [7:0] expA, expB;
    wire [8:0] expSum;
    assign expA = a[30:23];
    assign expB = b[30:23];
    assign expSum = expA + expB - 8'd127;

    // Lógica de mantissas 
    wire [22:0] mantA, mantB;
    assign mantA = a[22:0];
    assign mantB = b[22:0];

    wire [23:0] completeMantA, completeMantB;
    assign completeMantA = {1'b1, mantA};
    assign completeMantB = {1'b1, mantB};

    // Multiplicación de mantisas
    wire [47:0] mantProduct;
    assign mantProduct = completeMantA * completeMantB;

    // Normalización del producto
    reg [22:0] mantOut;
    reg [7:0] expOut;
    always @(*) begin
        if (mantProduct[47] == 1) begin
            mantOut = mantProduct[46:24]; // Mantisa normalizada
            expOut = expSum[7:0] + 1; // Ajustar el exponente
        end else begin
            mantOut = mantProduct[45:23];
            expOut = expSum[7:0];
        end
    end
    

     // Construcción del resultado final
    always @(*) begin
        if (expOut < 0 || expOut >= 255) begin
            result = 32'b0; // Underflow o overflow
        end else begin
            result = {signOut, expOut, mantOut};
        end
    end

endmodule