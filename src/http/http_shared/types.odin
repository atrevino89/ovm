package http_shared

Method :: enum {
	GET,
	POST,
	PUT,
	DELETE,
}

Response_Mode :: enum {
	Memory,
	File,
}

File_Config :: struct {
	filename: string,
}

RequestConfig :: struct {
	method:        Method,
	url:           string,
	response_mode: Response_Mode,
	file:          File_Config,
}

Response :: struct {
	ok:          bool,
	status_code: int,
	body:        []u8,
}

GithubAsset :: struct {
	url:                  string,
	name:                 string, // example: "odin-linux-amd64-dev-2026-03.tar.gz"
	browser_download_url: string,
}

GithubRelease :: struct {
	url:          string,
	name:         string,
	assets_url:   string,
	tag_name:     string,
	published_at: string,
	assets:       []GithubAsset,
}

