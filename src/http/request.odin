package http

import http_shared "./http_shared"
import curl "./internal/curl"

request :: proc(config: http_shared.RequestConfig) {

	// TODO: will remove the config struct from curl.odin
	// need to doa proper GET / POST and remove file writing
	curl.request(config)

}

