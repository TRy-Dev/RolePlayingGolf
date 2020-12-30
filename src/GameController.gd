extends Node

func _ready() -> void:
	OS.set_current_screen(0)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
