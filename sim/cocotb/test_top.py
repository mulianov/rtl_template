import os
from glob import glob
from pathlib import Path

from cocotb_tools.runner import get_runner

tests_dir = os.path.abspath(os.path.dirname(__file__))
rtl_dir = os.path.abspath(os.path.join(tests_dir, "..", "..", "rtl"))


def test_top_runner():
    hdl_toplevel_lang = "verilog"
    sim = os.getenv("COCOTB_SIM", "icarus")
    dut = os.getenv("module_top", "top")

    verilog_sources = glob(rtl_dir + "/*.sv")

    runner = get_runner(sim)
    runner.build(
        sources=verilog_sources,
        hdl_toplevel=dut,
        always=True,
        waves=True,
        verbose=True,
    )
    runner.test(
        hdl_toplevel="top",
        test_module="top_cocotb,",
        waves=True,
    )


if __name__ == "__main__":
    test_top_runner()
