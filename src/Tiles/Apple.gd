extends Tile

func on_player_entered(player: Player) -> void:
	ParticleController.play("blood", global_position)
	AudioController.sfx.play_at("crunch", global_position)
	destroy()
