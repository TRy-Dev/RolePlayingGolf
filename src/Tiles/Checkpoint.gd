extends Tile

func on_player_entered(player: Player) -> void:
	AudioController.sfx.play("checkpoint")
	GlobalState.save_state()
