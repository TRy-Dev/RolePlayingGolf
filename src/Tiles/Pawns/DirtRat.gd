extends Pawn

func burrow() -> void:
	collider.set_disabled(true, true)
	ParticleController.play("dust", global_position)
	AnimationController.play(anim_player, "hide")
	AudioController.sfx.play_at("dirt_move", global_position)

func unburrow() -> void:
	collider.set_disabled(false, false)
	ParticleController.play("dust", global_position)
	AnimationController.play(anim_player, "show", false)
	AudioController.sfx.play_at("dirt_move", global_position)

func on_player_entered(player: Player) -> void:
	collider.set_disabled(true, true)
	destroy()

#func on_player_exited(player: Player) -> void:
#	pass

func destroy() -> void:
	AudioController.sfx.play_at("rat_squeak", global_position)
	.destroy()
