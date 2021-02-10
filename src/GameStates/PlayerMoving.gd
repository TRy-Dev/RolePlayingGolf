extends GameState

func update(input: Dictionary) -> void:
	var player = input["player"]
	player.update()
	if player.get_speed_sq() < Math.EPSILON:
		emit_signal("finished", "GridWorldMoving")
		return
	.update(input)
