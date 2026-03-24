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

