extends Pawn

func burrow() -> void:
	collider.set_disabled(true, true)
	AnimationController.play(anim_player, "hide")

func unburrow() -> void:
	collider.set_disabled(false, false)
	AnimationController.play(anim_player, "appear", false)

func on_player_entered(player: Player) -> void:
	collider.set_disabled(true, true)
	destroy()
#	AudioController.sfx.play_at("wall_hit", global_position)

func on_player_exited(player: Player) -> void:
	pass
