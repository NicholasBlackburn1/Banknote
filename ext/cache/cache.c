#include "cache.h"
VALUE Cache = Qnil;

/*
 * Document-module: Cache
 *
 * Read and write to the cache.
 */
void Init_cache() {
	Cache = rb_define_module("Cache");
	/*
	* @overload write(str)
	* 	Write data to the cache.
	* 	@note On failure, raises a ruby exception.
	*
	* 	@param str [String] The data to write.
	*
	* 	@return [Fixnum] 0 on success, negative on error.
	*/
	rb_define_method(Cache, "write", method_write, 1);
	/*
	* Read all the data from the cache.
	* @note On failure, raises a ruby exception.
	*
	* @return [String] The cache data.
	*/
	rb_define_method(Cache, "read", method_read, 0);
	/*
	* @overload stale(dur)
	* 	Determine if the cache has existed longer than a specified time.
	* 	@note On failure, raises a ruby exception.
	*
	* 	@param dur [String] The time, in seconds.
	*
	* 	@return [Boolean, Fixnum] True or false, nil if error.
	*/
	rb_define_method(Cache, "stale", method_stale, 1);
	/*
	* Clear the cache.
	* @note On failure, raises a ruby exception.
	*
	* @return 0 on success, negative value on error.
	*/
	rb_define_method(Cache, "purge", method_purge, 0);
}

// Returns a pointer to the cache file
FILE* open_cache(const char *mode) {
	return fopen("ext/cache/cache.json", mode);
}

// Write to the cache file
VALUE method_write(VALUE self, VALUE str) {
	// Open the file
	FILE* cache = open_cache("w");
	if (!cache) {
		rb_raise(rb_eRuntimeError, "Error code %d", FILE_OPEN_ERROR);
		return INT2NUM(-1);
	}
	// Get the time
	long timecode = get_timecode();
	int tcwrite = fprintf(cache, "<%ju>\n", timecode);
	if (tcwrite < 0) {
		rb_raise(rb_eRuntimeError, "Error code %d", TIMECODE_ERROR);
		return INT2NUM(-1);		}
	int write = fputs(StringValuePtr(str), cache);
	if (write == EOF) {
		rb_raise(rb_eRuntimeError, "Error code %d", FILE_WRITE_ERROR);
		return INT2NUM(-1);
	}
	fclose(cache);
	return INT2NUM(0);
}

VALUE method_read(VALUE self) {
	FILE* cache = open_cache("r");
	if (!cache) {
		rb_raise(rb_eRuntimeError, "Error code %d", FILE_OPEN_ERROR);
		return INT2NUM(-1);
	}
	char *buffer;
	fseek(cache, 0L, SEEK_END);
	long cache_size = ftell(cache);
	printf(" %ld ", cache_size);

	if (cache_size > MAX_CACHE_BYTES) {
		method_purge(self);
		printf(" FULL %ld > %i ", cache_size, MAX_CACHE_BYTES);
	}

	rewind(cache);

	buffer = (char*)calloc(cache_size, sizeof(char));

	if (buffer == NULL) {
		rb_raise(rb_eRuntimeError, "Error code %d", MEMORY_ERROR);
		return INT2NUM(-1);
	}

	fread(buffer, sizeof(char), cache_size, cache);
	fclose(cache);

	VALUE read = rb_str_new_cstr(buffer);
	free(buffer);
	fclose(cache);
	return read;
}

VALUE method_stale(VALUE self, VALUE dur) {
	char* cache_str = read_timecode();
	if (cache_str == NULL) {
		rb_raise(rb_eRuntimeError, "Error code %d", TIMECODE_ERROR);
		return INT2NUM(-1);
	}
	long cache_tc = atol(cache_str);
	long current_tc = get_timecode();
	free(cache_str);
	if ((current_tc - cache_tc) > NUM2LONG(dur)) {
		return Qtrue;
	} else {
		return Qfalse;
	}
}

VALUE method_purge(VALUE self) {
	FILE* cache = open_cache("w");
	if (cache == NULL) {
		rb_raise(rb_eRuntimeError, "Error code %d", FILE_OPEN_ERROR);
		return INT2NUM(-1);
	}
	long timecode = get_timecode();
	int tcwrite = fprintf(cache, "<%ju>\n{}", timecode);
	if (tcwrite < 0) {
		rb_raise(rb_eRuntimeError, "Error code %d", TIMECODE_ERROR);
		return INT2NUM(-1);
	}
	fclose(cache);
	return INT2NUM(0);
}

char* read_timecode() {
	FILE* cache = open_cache("r");
	long tc_size;
	char* timecode;

	int c = fgetc(cache);
	if (c != 60) {
		return NULL;
	}
	while (c != 62) {
		c = fgetc(cache);
	}
	fseek(cache, -2L, SEEK_CUR);
	tc_size = ftell(cache);
	rewind(cache);
	fseek(cache, 1, SEEK_CUR);
	timecode = (char*)calloc(tc_size, sizeof(char));
	fread(timecode, sizeof(char), tc_size, cache);
	fclose(cache);
	return timecode;
}

long get_timecode() {
	return (long)time(NULL);
}
