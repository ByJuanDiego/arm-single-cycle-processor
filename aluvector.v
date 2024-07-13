module aluvector (
    input  [31:0] imm32,
    input  [31:0] vr2_0, // Vector de entrada, elemento 0
    input  [31:0] vr2_1, // Vector de entrada, elemento 1
    input  [31:0] vr2_2, // Vector de entrada, elemento 2
    input  [31:0] vr2_3, // Vector de entrada, elemento 3
    input  [31:0] vr2_4, // Vector de entrada, elemento 4
    input  [2:0]  ALUOp, // Señal de operación de la ALU (0: Suma, 1: Resta, 2: AND, 3: OR)
    output reg [31:0] result_0, // Resultado de la operación ALU para elemento 0
    output reg [31:0] result_1, // Resultado de la operación ALU para elemento 1
    output reg [31:0] result_2, // Resultado de la operación ALU para elemento 2
    output reg [31:0] result_3, // Resultado de la operación ALU para elemento 3
    output reg [31:0] result_4, // Resultado de la operación ALU para elemento 4
    output wire [3:0] ALUFlags // Banderas de la ALU

);
    
    reg [3:0] flags_0;
    reg [3:0] flags_1;
    reg [3:0] flags_2;
    reg [3:0] flags_3;
    reg [3:0] flags_4;

    // Realización de la operación para el primer elemento del vector
    alu alu_instance_0 (
        .a(vr2_0),
        .b(imm32),
        .ALUControl(ALUOp),
        .Result(result_0),
        .ALUFlags(flags_0)
    );

    // Realización de la operación para el segundo elemento del vector
    alu alu_instance_1 (
        .a(vr2_1),
        .b(imm32),
        .ALUControl(ALUOp),
        .Result(result_1),
        .ALUFlags(flags_1)
    );

    // Realización de la operación para el tercer elemento del vector
    alu alu_instance_2 (
        .a(vr2_2),
        .b(imm32),
        .ALUControl(ALUOp),
        .Result(result_2),
        .ALUFlags(flags_2)
    );

    // Realización de la operación para el cuarto elemento del vector
    alu alu_instance_3 (
        .a(vr2_3),
        .b(imm32),
        .ALUControl(ALUOp),
        .Result(result_3),
        .ALUFlags(flags_3)
    );

    // Realización de la operación para el quinto elemento del vector
    alu alu_instance_4 (
        .a(vr2_4),
        .b(imm32),
        .ALUControl(ALUOp),
        .Result(result_4),
        .ALUFlags(flags_4)
    );

    // Asignación de las banderas finales
    assign ALUFlags = flags_4;

endmodule
