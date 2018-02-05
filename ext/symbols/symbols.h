#include <ruby.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define FILE_OPEN_ERROR 1
#define FILE_WRITE_ERROR 2

void Init_symbols();

VALUE method_read(VALUE self);
