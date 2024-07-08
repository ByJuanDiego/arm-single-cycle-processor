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
    wire [22:0] mantissa_a, mantissa_b;

    // Other signals needed for IEEE-754 processing
    reg         sign_result;
    reg  [7:0]  exponent_result;
    reg  [23:0] mantissa_result; // Need an extra bit for rounding

    // Extract sign, exponent, and mantissa from inputs a and b
    assign sign_a = a[31];
    assign exponent_a = a[30:23];
    assign mantissa_a = {1'b1, a[22:0]}; // Append implied leading '1'

    assign sign_b = b[31];
    assign exponent_b = b[30:23];
    assign mantissa_b = {1'b1, b[22:0]}; // Append implied leading '1'

    // Implement ALU operation (Addition of two floating-point numbers)
    always @(*)
    begin
        if (ALUControl == 2'b00) begin
            // Add mantissas with alignment of exponents
            integer add_exp_diff;
            integer signed_mantissa_b;
            
            signed_mantissa_b = { ~ b[31], b[22:0] };

            add_exp_diff = exponent_a - exponent_b;

            if (add_exp_diff > 0) begin
                // Shift mantissa_b right to align with mantissa_a
                mantissa_b = mantissa_b >> add_exp_diff;
                exponent_result = exponent_a;
            end else if (add_exp_diff < 0) begin
                // Shift mantissa_a right to align with mantissa_b
                mantissa_a = mantissa_a >> (-add_exp_diff);
                exponent_result = exponent_b;
            end else begin
                // Exponents are equal
                exponent_result = exponent_a;
            end

            // Perform addition of mantissas
            if (sign_a == sign_b) begin
                // Signs are the same, add mantissas directly
                mantissa_result = mantissa_a + mantissa_b;
                sign_result = sign_a;
            end else if (mantissa_a > mantissa_b) begin
                // Different signs, a > b
                mantissa_result = mantissa_a - mantissa_b;
                sign_result = sign_a;
            end else begin
                // Different signs, b > a
                mantissa_result = mantissa_b - mantissa_a;
                sign_result = sign_b;
            end

            // Normalize mantissa_result
            if (mantissa_result[24]) begin
                // Mantissa overflow, shift right and adjust exponent
                mantissa_result = mantissa_result >> 1;
                exponent_result = exponent_result + 1;
            end

            // Round the mantissa_result
            if (mantissa_result[23:0] > 24'h800000) begin
                // Round up
                mantissa_result = mantissa_result + 1;
                if (mantissa_result[24]) begin
                    // Mantissa overflow due to rounding
                    mantissa_result = mantissa_result >> 1;
                    exponent_result = exponent_result + 1;
                end
            end

            neg = sign_result;
            zero = (mantissa_result == 24'h000000 && exponent_result == 8'h00);            
            overflow = (exponent_result > 8'hFF);

            // Determine CARRY flag (context-specific, implement as needed)
            // Example: Set CARRY flag for rounding carry
            // ALUFlags[1] = ...;

        end
    end

    // Assemble result back into IEEE-754 format
    assign Result = {sign_result, exponent_result, mantissa_result[22:0]};
    assign ALUFlags = {neg, zero, carry, overflow};

endmodule
