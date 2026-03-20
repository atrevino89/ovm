package platform

import http_shared "../http/http_shared"
import "core:encoding/json"
import "core:fmt"
import "core:strings"

get_platform :: proc() -> string {
	os_name: string

	when ODIN_OS == .Windows {
		os_name = "windows"
		compression_name = "zip"
	} else when ODIN_OS == .Linux {
		os_name = "linux"
	} else when ODIN_OS == .Darwin {
		os_name = "macOS"
	} else {
		os_name = "Unknown"
	}

	arch_name: string

	when ODIN_ARCH == .amd64 {
		arch_name = "amd64"
	} else when ODIN_ARCH == .arm64 {
		arch_name = "arm64"
	} else {
		arch_name = "unknown"
	}


	return fmt.tprintf("%s-%s", os_name, arch_name)

}

get_filename :: proc(url: string) -> string {
	if len(url) == 0 do return ""

	i := strings.last_index(url, "/")
	if i == -1 || i == len(url) - 1 do return ""

	return url[i + 1:]
}

parse_json_response_to_release :: proc(
	resp: http_shared.Response,
	releases: ^[]http_shared.GithubRelease,
) {
	err := json.unmarshal(resp.body, releases)
	if err != nil {
		fmt.println("json error:", err)
		// return resp
	}
}

