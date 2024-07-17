module clk_divider(
    input clk,
    input rst,
    output led
    );
 
wire [28:0] din;
wire [28:0] clkdiv; 
 
dff dff_inst0 (
    .clk(clk),
    .rst(rst),
    .D(din[0]),
    .Q(clkdiv[0])
);

genvar i;
generate
for (i = 1; i < 29; i=i+1) 
begin : dff_gen_label
    dff dff_inst (
        .clk(clkdiv[i-1]),
        .rst(rst),
        .D(din[i]),
        .Q(clkdiv[i])
    );
    end
endgenerate

assign din = ~clkdiv;
 
assign led = clkdiv[28];
 
endmodule
