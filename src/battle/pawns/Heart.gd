extends Pawn

func _on_Area2D_body_entered(body: Node) -> void:
	SoundEffects.play_audio("player-hurt")
	_destroy()

func _on_Area2D_area_entered(area: Area2D) -> void:
	SoundEffects.play_audio("player-hurt")
	_destroy()
