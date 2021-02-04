extends State

class_name GameState

func update(input: Dictionary) -> void:
	if input["controls"]["pause"]:
		emit_signal("finished", "GamePaused")
