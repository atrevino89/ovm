package main

import http_shared "./http/http_shared"
import "core:fmt"
import "core:strings"

get_download_link :: proc(release: http_shared.GithubRelease, platform: string) -> (string, bool) {
	url: string
	for a in release.assets {
		if strings.contains(a.browser_download_url, platform) {
			return a.browser_download_url, true
		}
	}
	return "", false
}

