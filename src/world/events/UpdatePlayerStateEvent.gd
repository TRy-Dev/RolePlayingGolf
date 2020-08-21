extends WorldEvent

export(String) var state_name
export(int) var delta

func _on_Area2D_body_entered(body: Node) -> void:
	Console.log_msg("Recieved %s %s" % [delta, state_name])
	if not enabled:
		return
	GameData.update_player_state(state_name, delta)
	_disable()
	._on_Area2D_body_entered(body)
