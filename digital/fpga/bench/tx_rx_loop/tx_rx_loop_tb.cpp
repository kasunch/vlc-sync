#include <cstdio>
#include <cstdlib>
#include <string>

#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vtx_rx_loop_tb.h"

#define TBASSERT(TB, A)                                                        \
  do {                                                                         \
    if (!(A)) {                                                                \
      (TB).closetrace();                                                       \
    }                                                                          \
    assert(A);                                                                 \
  } while (0);

template <class VA> class TestBench {

protected:
  VA *va_core_;
  std::string vcd_file_name_;
  VerilatedVcdC *vcd_trace_;
  uint64_t tick_count_;

  virtual void OpenTrace() {
    if (!vcd_file_name_.empty() && vcd_trace_ == NULL) {
      vcd_trace_ = new VerilatedVcdC;
      vcd_trace_->set_time_resolution("1 s");
      vcd_trace_->set_time_unit("1 s");
      va_core_->trace(vcd_trace_, 99);
      vcd_trace_->open(vcd_file_name_.c_str());
    }
  }

  virtual void CloseTrace(void) {
    if (vcd_trace_) {
      vcd_trace_->close();
      delete vcd_trace_;
      vcd_trace_ = NULL;
    }
  }

public:
  TestBench(void) : vcd_trace_(NULL), tick_count_(0l) {
    va_core_ = new VA;
    Verilated::traceEverOn(true);
  }

  virtual ~TestBench(void) {
    CloseTrace();
    delete va_core_;
    va_core_ = NULL;
  }

  void Initialize() {

    OpenTrace();

    va_core_->i_clk = 0;
    va_core_->eval(); /* Get initial values set properly. */
    if (vcd_trace_ != NULL) {
      vcd_trace_->dump((uint64_t)(0));
      vcd_trace_->flush();
    }
  }

  void SetTraceFile(const char *name) { vcd_file_name_ = name; }

  virtual void Tick(void) {

    va_core_->i_clk = 0;
    va_core_->eval();
    if (vcd_trace_) {
      vcd_trace_->dump((uint64_t)(tick_count_));
    }

    tick_count_++;

    va_core_->i_clk = 1;
    va_core_->eval();
    if (vcd_trace_) {
      vcd_trace_->dump((uint64_t)(tick_count_));
      vcd_trace_->flush();
    }

    tick_count_++;
  }

  uint64_t TickCount(void) { return tick_count_; }
};

int main(int argc, char **argv) {

  Verilated::commandArgs(argc, argv);

  TestBench<Vtx_rx_loop_tb> *tb = new TestBench<Vtx_rx_loop_tb>;

  tb->SetTraceFile("tx_rx_loop_tb-verilator.vcd");
  tb->Initialize();

  while (!Verilated::gotFinish()) {
    tb->Tick();
  }

  exit(EXIT_SUCCESS);
}
