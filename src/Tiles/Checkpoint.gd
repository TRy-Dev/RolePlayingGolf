extends Tile

func on_player_entered(player: Player) -> void:
	GlobalState.save_state()
