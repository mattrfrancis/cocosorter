# Test counter_module

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from cocotb.binary import BinaryValue

# Tests

@cocotb.test()
async def basic_timing_test(dut):
	
	# Setup
	cocotb.start_soon(Clock(dut.clk, 1, units = "ns").start())
	dut.reset.value = 1

	# Wait for two rising edges
	for _ in range(2):
		await RisingEdge(dut.clk)

	# Release reset and init values
	dut.reset.value = 0
	dut.valid.value = 1;
	dut.data_in.value = BinaryValue(value = 0, n_bits = 64)
	await RisingEdge(dut.clk)
	dut.valid.value = 0;

	# If there are 8 inputs there should be six delays

	#for _ in range(7):
	#	await RisingEdge(dut.clk)
	await RisingEdge(dut.done)


	assert dut.done.value == 1, "done is not asserted!"
	
