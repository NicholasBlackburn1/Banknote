#include <ruby.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define FILE_OPEN_ERROR 1
#define FILE_WRITE_ERROR 2
#define FILE_READ_ERROR 3
#define MEMORY_ERROR 4
#define TIMECODE_ERROR 5

#define MAX_KEEP_SECONDS 1

void Init_cache();

VALUE method_write(VALUE self, VALUE str);

VALUE method_read(VALUE self);

VALUE method_stale(VALUE self, VALUE dur);

VALUE method_purge(VALUE self);

char* read_timecode();

long get_timecode();
