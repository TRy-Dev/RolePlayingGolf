extends Node

func play(anim_player :AnimationPlayer, name :String, reset := true) -> void:
	if anim_player.has_animation(name):
		if reset:
			anim_player.play("_reset")
			anim_player.queue(name)
		else:
			anim_player.play(name)
	else:
		push_error("HEY! Animation does not exist. Name: %s. Parent %s" % \
				[name, anim_player.owner.name])

func queue(anim_player :AnimationPlayer, name :String, reset := true) -> void:
	if anim_player.has_animation(name):
		if reset:
			anim_player.queue("_reset")
		if anim_player.get_animation(anim_player.current_animation).loop:
			push_error("HEY! Trying to queue animation %s after looping animation %s" % \
					[name, anim_player.current_animation])
		anim_player.queue(name)
	else:
		push_error("HEY! Animation does not exist. Name: %s. Parent %s" % \
				[name, anim_player.owner.name])

func reset(anim_player :AnimationPlayer) -> void:
	anim_player.play("_reset")
