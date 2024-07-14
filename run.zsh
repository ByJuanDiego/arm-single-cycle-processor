iverilog -o dsn testbench.v adder.v alu.v arm.v condcheck.v condlogic.v controller.v datapath.v decode.v dmem.v extend.v flopenr.v flopr.v imem.v mux2.v regfile.v top.v vector_regfile.v aluvector.v
vvp dsn
gtkwave test.vcd
