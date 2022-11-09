import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def test_matrix(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 166, units="us")
    cocotb.fork(clock.start())
    
    await ClockCycles(dut.clk, 6000)

