package main

import http_shared "./http/http_shared"
import "core:encoding/json"
import "core:fmt"
import "core:strings"
import "http"

main :: proc() {
	releases_link := "https://api.github.com/repos/odin-lang/Odin/releases?per_page=50&page=1"

	config := http_shared.RequestConfig {
		method        = .GET,
		url           = releases_link,
		response_mode = .Memory,
	}

	resp := http.request(config)

	releases: []http_shared.GithubRelease
	defer delete(releases)

	err := json.unmarshal(resp.body, &releases)
	if err != nil {
		fmt.println("json error:", err)
		return
	}

	if !resp.ok {
		return
	}

	platform := get_platform()
	download_url, ok := get_download_link(releases[0], platform)

	if !ok {
		fmt.println("URL not found")
		return
	}

	filename := get_filename(download_url)
	fmt.println("status:", resp.status_code)


	config = http_shared.RequestConfig {
		method = .GET,
		url = download_url,
		response_mode = .File,
		file = {filename = filename},
	}

	resp = http.request(config)
	if !resp.ok {
		return
	}

	fmt.println("download ok, status:", resp.status_code)
}

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

