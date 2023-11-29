SIM ?= icarus
TOPLEVEL_LANG ?= verilog
VERILOG_SOURCES = bitonic.sv
TOP_LEVEL = bitonic_sorter
MODULE = testbench
include $(shell cocotb-config --makefiles)/Makefile.sim
