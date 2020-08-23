extends WorldEvent

export(String) var state_name
export(int) var delta

func _init() -> void:
	event_type = "update-state"

func _on_Area2D_body_entered(body: Node) -> void:
	if not enabled:
		return
	match state_name:
		"exp":
			Console.log_msg("Nasty bug (+1 exp)")
		"gold":
			Console.log_msg("Gold! (+5 gold)")
	
#	Console.log_msg("Recieved %s %s" % [delta, state_name])
	GameData.update_player_state(state_name, delta)
	_disable()
	._on_Area2D_body_entered(body)

func get_state() -> Dictionary:
	var state = .get_state()
	state["state_name"] = state_name
	state["delta"] = delta
	return state

func set_state(state) -> void:
	.set_state(state)
	state_name = state["state_name"]
	delta = state["delta"]
