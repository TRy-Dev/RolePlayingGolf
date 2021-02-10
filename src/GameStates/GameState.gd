extends State

class_name GameState

var world
var player
var camera
var camera_target
var gui

func initialize() -> void:
	var global_objects = owner.get_global_objects()
	world = global_objects["world"]
	player = global_objects["player"]
	camera = global_objects["camera"]
	camera_target = global_objects["camera_target"]
	gui = global_objects["gui"]

func update(input: Dictionary) -> void:
	if input["controls"]["pause"]:
		emit_signal("finished", "GamePaused")
