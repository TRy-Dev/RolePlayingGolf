extends Tile

export(float, 0.0, 1.0) var collision_velocity_multiplier = 0.7

func initialize(grid_pos: Vector2, idx: int) -> void:
	.initialize(grid_pos, idx)
	ParticleController.play("dust", global_position)
	AudioController.sfx.play_at("dirt_move", global_position)

func on_player_entered(player: Player) -> void:
	player.multiply_velocity(collision_velocity_multiplier)
	destroy()

func destroy():
	ParticleController.play("dust", global_position)
	AudioController.sfx.play_at("dirt_move", global_position)
	.destroy()

#func on_player_exited(player: Player) -> void:
#	pass
