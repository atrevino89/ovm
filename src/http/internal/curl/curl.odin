package http_internal

import http_shared "../../http_shared"
import "base:runtime"
import "core:c"
import "core:fmt"
import "core:os"
import curl "vendor:curl"

Write_Context :: struct {
	file: ^os.File,
}

write_fn :: proc "c" (ptr: rawptr, size: c.size_t, nmemb: c.size_t, userdata: rawptr) -> c.size_t {
	context = runtime.default_context()

	ctx := cast(^Write_Context)userdata
	total := int(size * nmemb)
	bytes := cast([^]u8)ptr
	data := bytes[:total]

	written, err := os.write(ctx.file, data)
	if err != nil || written != total {
		return c.size_t(0)
	}

	return c.size_t(written)
}


request :: proc(config: http_shared.RequestConfig) {
	if curl.global_init(curl.GLOBAL_DEFAULT) != curl.code.E_OK {
		fmt.println("curl global_init failed")
		return
	}
	defer curl.global_cleanup()

	handle := curl.easy_init()
	if handle == nil {
		fmt.println("curl easy_init failed")
		return
	}
	defer curl.easy_cleanup(handle)

	// TODO: implement if need to download the file or not
	file, err := os.create(config.file.filename)
	if err != nil {
		fmt.println("file error:", err)
		return
	}
	defer os.close(file)

	ctx := Write_Context {
		file = file,
	}

	curl.easy_setopt(handle, curl.option.URL, config.url)
	curl.easy_setopt(handle, curl.option.FOLLOWLOCATION, 1)
	curl.easy_setopt(handle, curl.option.USERAGENT, "ovm/1.0")
	curl.easy_setopt(handle, curl.option.WRITEFUNCTION, write_fn)
	curl.easy_setopt(handle, curl.option.WRITEDATA, &ctx)

	res := curl.easy_perform(handle)
	if res != curl.code.E_OK {
		fmt.println("download failed:", string(curl.easy_strerror(res)))
		return
	}

	fmt.println("Download completed")

}

