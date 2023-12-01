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
	dut.data_in.value = BinaryValue(value = 0, n_bits = 64, bigEndian = False)
	await RisingEdge(dut.clk)
	dut.valid.value = 0;

	# If there are 8 inputs there should be six delays

	for _ in range(6):
		await RisingEdge(dut.clk)
	#await RisingEdge(dut.done)

	assert dut.done.value == 1, "done is not asserted!"
	
@cocotb.test()
async def basic_add(dut):
	
	# Setup
	cocotb.start_soon(Clock(dut.clk, 1, units = "ns").start())
	dut.reset.value = 1

	# Wait for two rising edges
	for _ in range(2):
		await RisingEdge(dut.clk)

	# Release reset and init values
	dut.reset.value = 0
	dut.valid.value = 1;
	dut.data_in.value = BinaryValue(value = 0, n_bits = 64, bigEndian = False)
	await RisingEdge(dut.clk)
	dut.valid.value = 0;

	# The input is 0 and each block will add 1 to each of its split inputs
	# So the final value should be 0x0000001000000300000010000006
	for _ in range(6):
		await RisingEdge(dut.clk)
	assert dut.done.value == 1, "done is not asserted!"
	assert dut.data_out.value == 281487861678086
