iverilog -o dsn testbench.v adder.v alu.v arm.v condcheck.v condlogic.v controller.v datapath.v decode.v dmem.v extend.v flopenr.v flopr.v imem.v mux2.v regfile.v top.v vecfile.v aluvec.v fp_add32.v fp_mul32.v clk_divider.v dff.v
vvp dsn
gtkwave test.vcd
