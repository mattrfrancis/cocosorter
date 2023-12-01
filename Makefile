SIM ?= icarus
TOPLEVEL_LANG ?= verilog
VERILOG_SOURCES = bitonic.sv bitonic_block.sv bitonic_node.sv
TOP_LEVEL = bitonic_top
MODULE = testbench
include $(shell cocotb-config --makefiles)/Makefile.sim
