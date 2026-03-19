package main

import http_shared "./http/http_shared"
import "core:encoding/json"
import "core:fmt"
import "core:strings"
import "http"

RELEASES_LINK :: "https://api.github.com/repos/odin-lang/Odin/releases?per_page=50&page=1"


get_download_link :: proc(release: http_shared.GithubRelease, platform: string) -> (string, bool) {
	for a in release.assets {
		if strings.contains(a.browser_download_url, platform) {
			return a.browser_download_url, true
		}
	}
	return "", false
}

fetch_releases :: proc(releases: ^[]http_shared.GithubRelease) -> http_shared.Response {
	fmt.println("Fetching releases")
	config := http_shared.RequestConfig {
		method        = .GET,
		url           = RELEASES_LINK,
		response_mode = .Memory,
	}
	resp := http.request(config)

	if !resp.ok {
		fmt.println("Something went wrong with the github release api call")
		return resp
	}

	err := json.unmarshal(resp.body, releases)
	if err != nil {
		fmt.println("json error:", err)
		return resp
	}
	return resp
}

download_version :: proc(release: string) {
	releases: []http_shared.GithubRelease
	// TODO: handle errors properly
	resp := fetch_releases(&releases)
	defer delete(releases)
	platform := get_platform()
	download_url, ok := get_download_link(releases[0], platform)

	if !ok {
		fmt.println("URL not found")
		return
	}

	filename := get_filename(download_url)
	fmt.println("status:", resp.status_code)


	config := http_shared.RequestConfig {
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

