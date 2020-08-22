extends WorldEvent

func _init() -> void:
	event_type = "checkpoint"

func _on_Area2D_body_entered(body: Node) -> void:
	if not body.get("is_moving") or not body.is_moving:
		return
	if not enabled:
		return
	._on_Area2D_body_entered(body)
#	_disable()
	GameData.save_state("checkpoint", false)
	GameData.reset_moves()
	emit_signal("world_event_reached", self)
	Console.log_msg("Checkpoint reached")

