extends GameState

func update(input: Dictionary) -> void:
	# Handle player rotation input
	
	# if shoot button pressed
	# emit_signal("finished", "PlayerMoving")
	# if interact button pressed
	# emit_signal("finished", "PlayerInteracting")
	pass
	# Don't update player moving here, as they are not moving 100%
	.update(input)
