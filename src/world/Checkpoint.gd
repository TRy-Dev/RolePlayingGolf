extends WorldEvent

func _on_Area2D_body_entered(body: Node) -> void:
	if not enabled:
		return
	GameData.save_state("checkpoint")
	enabled = false
