package commands

import github "app:github"
import http_shared "app:http/http_shared"
import "core:fmt"

// TODO: add an ActualContext struct that contains the versions installed already on the system
// in the list, add "version" -> installed for example
list :: proc(args: []string) -> ([]http_shared.GithubRelease, bool) {
	releases: []http_shared.GithubRelease
	// TODO: handle errors properly
	resp := github.fetch_releases(&releases)
	// defer delete(releases)
	err := github.parse_json_response_to_release(resp, &releases)
	if err {
		fmt.println("there was an error")
		return nil, false
	}

	for r in releases {
		fmt.println(r.tag_name)
	}

	return releases, true
}

