SIM ?= icarus
TOPLEVEL_LANG ?= verilog
VERILOG_SOURCES = counter.sv
TOP_LEVEL = counter_module
MODULE = testbench
include $(shell cocotb-config --makefiles)/Makefile.sim
