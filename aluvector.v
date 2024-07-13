module aluvector (
    input  [31:0] imm32,
    input  [31:0] vr2 [4:0], // Vector de entrada
    input  [2:0]  ALUOp,    // Señal de operación de la ALU (0: Suma, 1: Resta, 2: AND, 3: OR)
    output reg [31:0] result [4:0], // Resultado de la operación ALU para cada elemento del vector
    output wire [3:0] ALUFlags // Banderas de la ALU
);
    reg [31:0] temp_result; // Variable temporal para almacenar resultados intermedios
    reg [3:0] flags; // Banderas temporales para cada operación individual
    assign flags = ALUFlags;

    always @* begin

        // Realización de las operaciones para cada elemento del vector
        for (int i = 0; i < 5; i = i + 1) begin
            alu alu_instance (
                .a(vr2[i]),
                .b(imm2),
                .ALUControl(ALUOp),
                .Result(temp_result),
                .ALUFlags(flags)
            );

            // Almacenamiento del resultado en el vector de resultados
            result[i] <= temp_result;
        end
    end

    assign ALUFlags = flags; // Asignación de las banderas finales

endmodule