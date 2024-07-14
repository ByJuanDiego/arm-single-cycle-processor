module aluvector (
    input wire [31:0] imm32,
    input wire [31:0] a_0, // Vector de entrada, elemento 0
    input wire [31:0] a_1, // Vector de entrada, elemento 1
    input wire [31:0] a_2, // Vector de entrada, elemento 2
    input wire [31:0] a_3, // Vector de entrada, elemento 3
    input wire [31:0] a_4, // Vector de entrada, elemento 4

    input wire [2:0]  ALUOp, // Señal de operación de la ALU (0: Suma, 1: Resta, 2: AND, 3: OR)
    output wire [31:0] Result_0, // Resultado de la operación ALU para elemento 0
    output wire [31:0] Result_1, // Resultado de la operación ALU para elemento 1
    output wire [31:0] Result_2, // Resultado de la operación ALU para elemento 2
    output wire [31:0] Result_3, // Resultado de la operación ALU para elemento 3
    output wire [31:0] Result_4  // Resultado de la operación ALU para elemento 4
);
    
    wire [3:0] flags_0;
    wire [3:0] flags_1;
    wire [3:0] flags_2;
    wire [3:0] flags_3;
    wire [3:0] flags_4;

    // Realización de la operación para el primer elemento del vector
    alu alu_instance_0 (
        .a(a_0),
        .b(imm32),
        .ALUControl(ALUOp),
        .Result(Result_0),
        .ALUFlags(flags_0)
    );

    // Realización de la operación para el segundo elemento del vector
    alu alu_instance_1 (
        .a(a_1),
        .b(imm32),
        .ALUControl(ALUOp),
        .Result(Result_1),
        .ALUFlags(flags_1)
    );

    // Realización de la operación para el tercer elemento del vector
    alu alu_instance_2 (
        .a(a_2),
        .b(imm32),
        .ALUControl(ALUOp),
        .Result(Result_2),
        .ALUFlags(flags_2)
    );

    // Realización de la operación para el cuarto elemento del vector
    alu alu_instance_3 (
        .a(a_3),
        .b(imm32),
        .ALUControl(ALUOp),
        .Result(Result_3),
        .ALUFlags(flags_3)
    );

    // Realización de la operación para el quinto elemento del vector
    alu alu_instance_4 (
        .a(a_4),
        .b(imm32),
        .ALUControl(ALUOp),
        .Result(Result_4),
        .ALUFlags(flags_4)
    );

endmodule
