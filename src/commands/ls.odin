package commands

import github "../github"
import http_shared "../http/http_shared"
import platform "../platform"
import "core:fmt"

// TODO: add an ActualContext struct that contains the versions installed already on the system
// in the list, add "version" -> installed for example
list :: proc(args: []string) {
	releases: []http_shared.GithubRelease
	// TODO: handle errors properly
	resp := github.fetch_releases(&releases)
	defer delete(releases)
	platform.parse_json_response_to_release(resp, &releases)
	for r in releases {
		fmt.println(r.tag_name)
	}
}

