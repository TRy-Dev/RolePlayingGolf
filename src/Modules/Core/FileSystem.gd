extends Node

const PATH_DELIMITER = "/"

func concat_path(paths: Array) -> String:
	var out = ""
	for p in paths:
		out += p + PATH_DELIMITER
	out.rstrip(PATH_DELIMITER)
	return out

func get_contents(path) -> Dictionary:
	var files = []
	var directories = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var name = dir.get_next()
		while name != "":
			if dir.current_is_dir():
				directories.append(name)
			else:
				if not name.ends_with(".import"):
					files.append(name)
			name = dir.get_next()
	else:
		push_error("HEY! An error occurred when trying to access the path: %s" % path)
	directories.erase(".")
	directories.erase("..")
	return {
		"files": files,
		"directories": directories,
	}

func get_files(path) -> Array:
	return get_contents(path)["files"]
	
func get_directories(path):
	return get_contents(path)["directories"]
