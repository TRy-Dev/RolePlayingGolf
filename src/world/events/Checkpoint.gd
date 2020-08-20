extends WorldEvent

func _init() -> void:
	event_type = "checkpoint"

func _on_Area2D_body_entered(body: Node) -> void:
	._on_Area2D_body_entered(body)
	if not enabled:
		return
	_disable()
	GameData.save_state("checkpoint")
	Console.log_msg("Game saved")
	
