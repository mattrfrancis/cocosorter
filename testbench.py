# Test counter_module

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from cocotb.binary import BinaryValue

# Tests

@cocotb.test()
async def basic_datain(dut):
	
	# Setup
	cocotb.start_soon(Clock(dut.clk, 1, units = "ns").start())
	dut.reset.value = 1

	# Wait for two rising edges
	for _ in range(2):
		await RisingEdge(dut.clk)

	# Release reset
	dut.reset.value = 0

	dut.valid.value = 1;
	dut.data_in.value = BinaryValue('11110000000011110011001111001100')

	await RisingEdge(dut.clk)
	await RisingEdge(dut.clk)
	assert dut.done.value == 1, "done is not asserted!"
	





