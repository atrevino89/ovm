package github

import http_shared "app:http/http_shared"
import "core:encoding/json"
import "core:strings"


get_filename :: proc(url: string) -> string {
	if len(url) == 0 do return ""

	i := strings.last_index(url, "/")
	if i == -1 || i == len(url) - 1 do return ""

	return url[i + 1:]
}

parse_json_response_to_release :: proc(
	resp: http_shared.Response,
	releases: ^[]http_shared.GithubRelease,
) -> bool {
	err := json.unmarshal(resp.body, releases)
	return err != nil
}

