package commands

import github "app:github"
// import http_shared "app:http/http_shared"
import "core:fmt"

/*
* Installs an Odin-lang release, defaults to the latest, else it accepts
* an existing version (tag / release name)
*/
install :: proc(args: []string) -> bool {
	// find the latest version
	fmt.println(args)
	if len(args) == 0 {
		// error for now if no version is given
		fmt.eprintln("No version given, please add version as argument")
		return false
	}
	version := args[0]

	github.download_version(version)
	//
	// downloads the latests
	//
	// installs somewhere (/tmp/dir for now)

	return true
}

