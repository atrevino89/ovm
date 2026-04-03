package main

import "commands"
import "core:fmt"
import "core:os"

main :: proc() {
	if len(os.args) < 2 {
		// TODO: handle error
		fmt.println("Enter a command")
		return
	}

	cmd := os.args[1]
	args := os.args[2:]
	switch cmd {
	case "install":
		commands.install(args)
	case "ls":
		commands.list(args)
	}

	// download_version("")
}


/**
* TASKS:
* 1. create a local dir in ~/.ovm/ to hold all files or configs
* 1. add a pre-check where we try to find the ~/.ovm/ dir (for install, ls, etc)
* 1. need to validate is the right tools are installed like:
*   - tools to decompress the .tar archive
    - OS to validate where to put the local ovm directory (for now only Linux / Unix - MacOs)
**/

