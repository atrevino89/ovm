package platform

import "core:fmt"

get_platform :: proc() -> string {
	os_name: string

	when ODIN_OS == .Windows {
		os_name = "windows"
		compression_name = "zip"
	} else when ODIN_OS == .Linux {
		os_name = "linux"
	} else when ODIN_OS == .Darwin {
		os_name = "macOS"
	} else {
		os_name = "Unknown"
	}

	arch_name: string

	when ODIN_ARCH == .amd64 {
		arch_name = "amd64"
	} else when ODIN_ARCH == .arm64 {
		arch_name = "arm64"
	} else {
		arch_name = "unknown"
	}


	return fmt.tprintf("%s-%s", os_name, arch_name)

}

