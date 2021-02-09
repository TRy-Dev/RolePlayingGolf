extends Tile

func on_player_entered(player: Player) -> void:
	ParticleController.play("dust", global_position)
	AudioController.sfx.play_at("bottle_break", global_position)
	destroy()
