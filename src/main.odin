package main

import http_shared "./http/http_shared"
import "http"

main :: proc() {
	releases := "https://api.github.com/repos/odin-lang/Odin/releases"
	assets := "https://api.github.com/repos/odin-lang/Odin/releases/<release>/assets"

	// TODO: need to detect the platform running to find the correct asset
	// - also need to let the use pick the version or use latest always

	config := http_shared.RequestConfig {
		method = http_shared.Method.GET,
		url = "https://github.com/odin-lang/Odin/releases/download/dev-2026-03/odin-linux-amd64-dev-2026-03.tar.gz",
		file = {filename = "odin.tar.gz", fetch_file = true},
	}

	http.request(config)
}

