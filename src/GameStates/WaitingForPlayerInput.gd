extends GameState

var charging_shot = false
var shot_charge = 0.0

var shot_charge_dir = 1 # or -1
const SHOT_CHARGE_SPEED = 1.5

func initialize() -> void:
	.initialize()

# Replace with calls to GlobalObjects inherited from GameState
func enter(previous: State) -> void:
	charging_shot = false
	shot_charge = 0.0
	player.set_trajectory_visible(true)
	gui.set_hit_bar_visible(true)
	player.set_hit_strength(0.3)
	
func exit(next: State) -> void:
	player.set_trajectory_visible(false)
	gui.set_hit_bar_visible(false)
	camera_target.force_reset_offset()
#	player.set_hit_strength(0.3)

func update(input: Dictionary) -> void:
#	var player = input["player"]
#	var cam_target = input["camera_target"]
	var look_dir = input["controls"]["look_direction"]
	var look_str = input["controls"]["look_strength"]
	
	if charging_shot:
		if input["controls"]["shoot_released"]:
			player.shoot()
			emit_signal("finished", "PlayerMoving")
			return
		shot_charge += shot_charge_dir * SHOT_CHARGE_SPEED * get_physics_process_delta_time()
		if shot_charge <= 0:
			shot_charge = 0.0
			shot_charge_dir = 1
		elif shot_charge >= 1:
			shot_charge = 1.0
			shot_charge_dir = -1
		var shot_charge_eased = Easing.Quad.easeInOut(shot_charge, 0.0, 1.0, 1.0)
		player.set_hit_strength(shot_charge_eased)
		return
		
	camera_target.set_offset(look_dir, look_str)
	camera_target.update()
	player.look_at(look_dir)
	player.update_trajectory_direction()
	if input["controls"]["interact"] and input["interaction"]:
		emit_signal("finished", "PlayerInteracting")
		return
	elif input["controls"]["shoot_pressed"]:
		player.set_hit_strength(0.0)
		charging_shot = true
	.update(input)
