#include <verilated.h>
#include <verilated_fst_c.h>
#include <math.h>

#include "Vtop_tb.h"

/* 1 timeprecision period passes... */
/* Toggle a fast (time/2 period) clock */
#define CYCLE() do { \
      contextp->timeInc(CLK_PERIOD / 2 * tu);  \
      tb->clk = !tb->clk;  \
      tb->eval(); \
  } while (0)

int main(int argc, char **argv, char **env) {
  const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
  vluint64_t t = 0;

  Verilated::debug(0);
  Verilated::randReset(2);
  Verilated::traceEverOn(true);
  Verilated::commandArgs(argc, argv);
  Verilated::mkdir("logs");
  Verilated::assertOn(false);
  VerilatedCov::zero();

  Vtop_tb *tb = new Vtop_tb;

  int clk = 0;

  uint32_t tu = pow(10, contextp->timeunit() - contextp->timeprecision());

  while (!contextp->gotFinish()) {
    CYCLE();
  }

  tb->final();

#if VM_COVERAGE
  Verilated::mkdir("logs");
  VerilatedCov::write("logs/coverage.dat");
#endif

  delete tb;
  tb = NULL;
  exit(0);
}
