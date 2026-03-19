package main

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
	case "ls":
		list(args)
	}

	// download_version("")
}

