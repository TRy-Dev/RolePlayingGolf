extends GameState

func update(input: Dictionary) -> void:
	# if interaction completed
	if input["controls"]["interact"]:
		emit_signal("finished", "WaitingForPlayerInput")
		return
	.update(input)
