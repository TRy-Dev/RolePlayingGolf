extends Tile

export(float, 0.0, 1.0) var collision_velocity_multiplier = 0.7

func on_player_entered(player: Player) -> void:
	player.multiply_velocity(collision_velocity_multiplier)
	destroy()

func on_player_exited(player: Player) -> void:
	pass
