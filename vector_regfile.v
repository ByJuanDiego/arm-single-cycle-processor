module vector_regfile (
    input wire clk,
    input wire we,
    input wire reset, 
    input wire [3:0] va1, // numero del vector entrada 
    input wire [3:0] vd2, // numero vector destino  
    input wire [31:0] wd2 [4:0], //valor al destino 
    output wire [31:0] vr2 [4:0] // valor del vector de entrada 
);
    reg [31:0] vreg [15:0][4:0]; // 15 vector registers, each with 5 elements

    //falta implementar logica reset 
    always @(posedge clk) begin
        if (we) begin
            vreg[vd2][0] <= wd[0];
            vreg[vd2][1] <= wd[1];
            vreg[vd2][2] <= wd[2];
            vreg[vd2][3] <= wd[3];
            vreg[vd2][4] <= wd[4];
        end
    end

    assign vr2[0] = vreg[va1][0];
    assign vr2[1] = vreg[va1][1];
    assign vr2[2] = vreg[va1][2];
    assign vr2[3] = vreg[va1][3];
    assign vr2[4] = vreg[va1][4];
endmodule