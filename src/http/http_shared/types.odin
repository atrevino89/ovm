package http_shared

Method :: enum {
	GET,
	POST,
	PUT,
	DELETE,
}

RequestConfig :: struct {
	method: Method,
	url:    string,
	file:   struct {
		filename:   string,
		fetch_file: bool,
	},
}

