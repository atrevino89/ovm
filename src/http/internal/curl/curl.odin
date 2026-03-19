package http_internal

import http_shared "../../http_shared"
import "base:runtime"
import "core:c"
import "core:fmt"
import curl "vendor:curl"

// NOTE: this file is shamelessly extracted from AI assistant.
// hope one day to improve it and make it more human.

foreign import libc "system:c"

foreign libc {
	fopen :: proc(path, mode: cstring) -> rawptr ---
	fclose :: proc(file: rawptr) -> c.int ---
}
Write_Context :: struct {
	data: [dynamic]u8,
}

write_to_memory_fn :: proc "c" (
	ptr: rawptr,
	size: c.size_t,
	nmemb: c.size_t,
	userdata: rawptr,
) -> c.size_t {
	context = runtime.default_context()

	ctx := cast(^Write_Context)userdata
	total := int(size * nmemb)

	bytes := cast([^]u8)ptr
	chunk := bytes[:total]

	append(&ctx.data, ..chunk)
	return c.size_t(total)
}

to_cstring :: proc(s: string) -> cstring {
	// Ojo: esto solo sirve si `s` ya es zero-terminated.
	// Mejor usa strings literales o construye uno temporal si hace falta.
	return cstring(raw_data(s))
}

cstring_buffer :: proc(s: string) -> []u8 {
	buf := make([]u8, len(s) + 1)
	copy(buf[:len(s)], s)
	buf[len(s)] = 0
	return buf
}

request :: proc(config: http_shared.RequestConfig) -> http_shared.Response {
	resp := http_shared.Response{}

	if curl.global_init(curl.GLOBAL_DEFAULT) != curl.code.E_OK {
		fmt.println("curl global_init failed")
		return resp
	}
	defer curl.global_cleanup()

	handle := curl.easy_init()
	if handle == nil {
		fmt.println("curl easy_init failed")
		return resp
	}
	defer curl.easy_cleanup(handle)

	curl.easy_setopt(handle, curl.option.URL, config.url)
	curl.easy_setopt(handle, curl.option.FOLLOWLOCATION, 1)
	curl.easy_setopt(handle, curl.option.USERAGENT, "ovm/1.0")

	switch config.response_mode {
	case .Memory:
		ctx := Write_Context {
			data = make([dynamic]u8),
		}
		defer delete(ctx.data)

		curl.easy_setopt(handle, curl.option.WRITEFUNCTION, write_to_memory_fn)
		curl.easy_setopt(handle, curl.option.WRITEDATA, &ctx)

		res := curl.easy_perform(handle)
		if res != curl.code.E_OK {
			fmt.println("download failed:", string(curl.easy_strerror(res)))
			return resp
		}

		status_code: c.long
		curl.easy_getinfo(handle, curl.INFO.RESPONSE_CODE, &status_code)

		resp.ok = true
		resp.status_code = int(status_code)

		resp.body = make([]u8, len(ctx.data))
		copy(resp.body, ctx.data[:])

		return resp

	case .File:
		filename_buf := cstring_buffer(config.file.filename)
		defer delete(filename_buf)

		c_filename := cstring(raw_data(filename_buf))
		c_mode := cstring("wb")
		fp := fopen(c_filename, c_mode)
		if fp == nil {
			fmt.println("file open failed:", config.file.filename)
			return resp
		}
		defer fclose(fp)

		curl.easy_setopt(handle, curl.option.WRITEDATA, fp)

		res := curl.easy_perform(handle)
		if res != curl.code.E_OK {
			fmt.println("download failed:", string(curl.easy_strerror(res)))
			return resp
		}

		status_code: c.long
		curl.easy_getinfo(handle, curl.INFO.RESPONSE_CODE, &status_code)

		resp.ok = true
		resp.status_code = int(status_code)
		return resp
	}

	return resp
}

