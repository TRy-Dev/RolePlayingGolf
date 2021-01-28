extends Pawn

func burrow() -> void:
	collider.set_disabled(true, true)
	AnimationController.play(anim_player, "hide")

func unburrow() -> void:
	collider.set_disabled(false, false)
	AnimationController.play(anim_player, "appear")
