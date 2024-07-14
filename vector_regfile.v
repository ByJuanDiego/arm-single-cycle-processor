module vector_regfile (
    input wire clk,
    input wire we,
    input wire reset,

    input wire [3:0] va1, // número del vector de entrada 
    input wire [3:0] vd2, // número vector destino  
    
    input wire [31:0] wd2_0, // valor de escritura de vector elemento 0
    input wire [31:0] wd2_1, // valor de escritura de vector elemento 1
    input wire [31:0] wd2_2, // valor de escritura de vector elemento 2
    input wire [31:0] wd2_3, // valor de escritura de vector elemento 3
    input wire [31:0] wd2_4, // valor de escritura de vector elemento 4
    
    output wire [31:0] vr2_0, // valor del vector de entrada, elemento 0
    output wire [31:0] vr2_1, // valor del vector de entrada, elemento 1
    output wire [31:0] vr2_2, // valor del vector de entrada, elemento 2
    output wire [31:0] vr2_3, // valor del vector de entrada, elemento 3
    output wire [31:0] vr2_4  // valor del vector de entrada, elemento 4
);

    reg [31:0] vreg [15:0][4:0]; // 15 registros de vectores, cada uno con 5 elementos

    // Lógica para la inicialización en reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Inicializar todos los registros de vectores con cero
            vreg[0][0] <= 0; vreg[0][1] <= 0; vreg[0][2] <= 0; vreg[0][3] <= 0; vreg[0][4] <= 0;
            vreg[1][0] <= 0; vreg[1][1] <= 0; vreg[1][2] <= 0; vreg[1][3] <= 0; vreg[1][4] <= 0;
            vreg[2][0] <= 0; vreg[2][1] <= 0; vreg[2][2] <= 0; vreg[2][3] <= 0; vreg[2][4] <= 0;
            vreg[3][0] <= 0; vreg[3][1] <= 0; vreg[3][2] <= 0; vreg[3][3] <= 0; vreg[3][4] <= 0;
            vreg[4][0] <= 0; vreg[4][1] <= 0; vreg[4][2] <= 0; vreg[4][3] <= 0; vreg[4][4] <= 0;
            vreg[5][0] <= 0; vreg[5][1] <= 0; vreg[5][2] <= 0; vreg[5][3] <= 0; vreg[5][4] <= 0;
            vreg[6][0] <= 0; vreg[6][1] <= 0; vreg[6][2] <= 0; vreg[6][3] <= 0; vreg[6][4] <= 0;
            vreg[7][0] <= 0; vreg[7][1] <= 0; vreg[7][2] <= 0; vreg[7][3] <= 0; vreg[7][4] <= 0;
            vreg[8][0] <= 0; vreg[8][1] <= 0; vreg[8][2] <= 0; vreg[8][3] <= 0; vreg[8][4] <= 0;
            vreg[9][0] <= 0; vreg[9][1] <= 0; vreg[9][2] <= 0; vreg[9][3] <= 0; vreg[9][4] <= 0;
            vreg[10][0] <= 0; vreg[10][1] <= 0; vreg[10][2] <= 0; vreg[10][3] <= 0; vreg[10][4] <= 0;
            vreg[11][0] <= 0; vreg[11][1] <= 0; vreg[11][2] <= 0; vreg[11][3] <= 0; vreg[11][4] <= 0;
            vreg[12][0] <= 0; vreg[12][1] <= 0; vreg[12][2] <= 0; vreg[12][3] <= 0; vreg[12][4] <= 0;
            vreg[13][0] <= 0; vreg[13][1] <= 0; vreg[13][2] <= 0; vreg[13][3] <= 0; vreg[13][4] <= 0;
            vreg[14][0] <= 0; vreg[14][1] <= 0; vreg[14][2] <= 0; vreg[14][3] <= 0; vreg[14][4] <= 0;
            vreg[15][0] <= 0; vreg[15][1] <= 0; vreg[15][2] <= 0; vreg[15][3] <= 0; vreg[15][4] <= 0;
        end
        else begin
            // Lógica de escritura cuando we está activo
            if (we) begin
                // Escribir el valor en el vector destino vd2
                vreg[vd2][0] <= wd2_0;
                vreg[vd2][1] <= wd2_1;
                vreg[vd2][2] <= wd2_2;
                vreg[vd2][3] <= wd2_3;
                vreg[vd2][4] <= wd2_4;
            end
        end
    end

    // Asignación de los valores de salida
    assign vr2_0 = vreg[va1][0];
    assign vr2_1 = vreg[va1][1];
    assign vr2_2 = vreg[va1][2];
    assign vr2_3 = vreg[va1][3];
    assign vr2_4 = vreg[va1][4];

endmodule
