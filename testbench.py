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
	dut.data_in.value = BinaryValue('11110000000011110000000000000000')

	await RisingEdge(dut.clk)
	await RisingEdge(dut.clk)
	await RisingEdge(dut.clk)
	await RisingEdge(dut.clk)
	await RisingEdge(dut.clk)
	assert dut.done.value == 1, "done is not asserted!"
	
# We are sorting descending

@cocotb.test()
async def basic_sort(dut):
	
	# Setup
	cocotb.start_soon(Clock(dut.clk, 1, units = "ns").start())
	dut.reset.value = 1

	# Wait for two rising edges
	for _ in range(2):
		await RisingEdge(dut.clk)

	# Release reset
	dut.reset.value = 0

	dut.valid.value = 1;
	dut.data_in.value = BinaryValue('01111111000000010000001001001001')

	await RisingEdge(dut.clk)
	await RisingEdge(dut.clk)
	await RisingEdge(dut.clk)
	await RisingEdge(dut.clk)
	await RisingEdge(dut.clk)
	assert dut.done.value == 1, "done is not asserted!"
	assert dut.data_out.value == BinaryValue('00000001000000100100100101111111');


#@cocotb.test()
#async def basic_sort2(dut):
#	
#	# Setup
#	cocotb.start_soon(Clock(dut.clk, 1, units = "ns").start())
#	dut.reset.value = 1
#
#	# Wait for two rising edges
#	for _ in range(2):
#		await RisingEdge(dut.clk)
#
#	# Release reset
#	dut.reset.value = 0
#
#	dut.valid.value = 1;
#	dut.data_in.value = BinaryValue('0000000101111111')
#
#	await RisingEdge(dut.clk)
#	await RisingEdge(dut.clk)
#	await RisingEdge(dut.clk)
#	assert dut.done.value == 1, "done is not asserted!"
#	assert dut.data_out.value == BinaryValue('0000000101111111');

