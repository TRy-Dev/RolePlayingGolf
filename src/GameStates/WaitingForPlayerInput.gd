extends GameState


func update(input: Dictionary) -> void:
	var player = input["player"]
	var cam_target = input["camera_target"]
	var look_dir = input["controls"]["look_direction"]
	var look_str = input["controls"]["look_strength"]
	
	cam_target.set_offset(look_dir, look_str)
	cam_target.update()
	player.look_at(look_dir)
	player.update_trajectory_direction()
	if input["controls"]["interact"]:
		if player.interact():
			emit_signal("finished", "PlayerInteracting")
			return
	elif input["controls"]["shoot_pressed"]:
		player.shoot()
		emit_signal("finished", "PlayerMoving")
		return
	.update(input)

#### Temporary

func enter(previous: State) -> void:
	owner.set_player_trajectory_visible(true)

func exit(next: State) -> void:
	owner.set_player_trajectory_visible(false)
	owner.reset_camera_target()
