# Test counter_module

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

# Tests

@cocotb.test()
async def basic_count(dut):
	
	# Setup
	cocotb.start_soon(Clock(dut.clk, 1, units = "ns").start())
	dut.reset.value = 1

	# Wait for two rising edges
	for _ in range(2):
		await RisingEdge(dut.clk)

	# Release reset
	dut.reset.value = 0


	for cnt in range(50):
		await RisingEdge(dut.clk)
		v_count = dut.count.value
		mod_cnt = cnt % 16
		assert v_count.integer == mod_cnt, "counter result is incorrect: %s != %s" % (str(dut.count.value), mod_cnt)

