module fp_add (
    input  [31:0] a, b,
    output reg [31:0] result
);

    wire        sign_a, sign_b;
    wire [7:0]  exponent_a, exponent_b;
    reg [23:0] mantissa_a, mantissa_b;

    reg         sign_result;
    reg  [7:0]  exponent_result;
    reg  [24:0] mantissa_result;

    assign sign_a = a[31];
    assign sign_b = b[31];
    assign exponent_a = a[30:23];
    assign exponent_b = b[30:23];
    
    integer add_exp_diff;

    always @(*)
    begin
        mantissa_a = {1'b1, a[22:0]};
        mantissa_b = {1'b1, b[22:0]};
        add_exp_diff = exponent_a - exponent_b;

        exponent_result = (add_exp_diff > 0) ? exponent_a :
                          (add_exp_diff < 0) ? exponent_b :
                          exponent_a;

        mantissa_a = (exponent_result <= 0)? mantissa_a >> (-add_exp_diff): mantissa_a;
        mantissa_b = (exponent_result > 0)? mantissa_b >> add_exp_diff : mantissa_b;

        mantissa_result = (sign_a == sign_b) ? mantissa_a + mantissa_b :
                          (sign_a == 1'b0 && mantissa_a >= mantissa_b) ? mantissa_a - mantissa_b :
                          (sign_a == 1'b0 && mantissa_a < mantissa_b)  ? mantissa_b - mantissa_a :
                          (sign_a == 1'b1 && mantissa_b >= mantissa_a) ? mantissa_b - mantissa_a :
                          (sign_a == 1'b1 && mantissa_b < mantissa_a)  ? mantissa_a - mantissa_b :
                          mantissa_a - mantissa_b;
                          
        sign_result = (sign_a == sign_b) ? sign_a :
                      (sign_a == 1'b0) ? (mantissa_a >= mantissa_b ? sign_a : sign_b) :
                      (sign_a == 1'b1) ? (mantissa_b >= mantissa_a ? sign_b : sign_a) :
                      sign_a;

        if (mantissa_result[24])
        begin
            mantissa_result = mantissa_result >> 1;
            exponent_result = exponent_result + 1;
        end

        result = {sign_result, exponent_result, mantissa_result[22:0]};
    end

endmodule
