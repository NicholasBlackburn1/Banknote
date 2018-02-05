#include "symbols.h"
VALUE Symbols = Qnil;

void Init_symbols() {
  Symbols = rb_define_module("Symbols");
  rb_define_method(Symbols, "read", method_read, 0);
}
