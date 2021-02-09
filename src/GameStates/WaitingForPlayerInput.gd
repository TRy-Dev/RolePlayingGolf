extends GameState

signal player_started_charging_shot()
signal player_stopped_charging_shot()

var charging_shot = false
var shot_charge = 0.0

var shot_charge_dir = 1 # or -1
const SHOT_CHARGE_SPEED = 1.0

func initialize() -> void:
	.initialize()
	connect("player_started_charging_shot", gui, "_on_player_started_charging_shot")
	connect("player_stopped_charging_shot", gui, "_on_player_stopped_charging_shot")

# Replace with calls to GlobalObjects inherited from GameState
func enter(previous: State) -> void:
	charging_shot = false
	shot_charge = 0.0
	player.set_trajectory_visible(true)
	player.set_hit_strength(0.3)
	camera.set_zoom_level("medium")
	
func exit(next: State) -> void:
	player.set_trajectory_visible(false)
	camera_target.force_reset_offset()
#	player.set_hit_strength(0.3)

func update(input: Dictionary) -> void:
	var look_dir = input["controls"]["look_direction"]
	var look_str = input["controls"]["look_strength"]
	
	camera_target.set_offset(look_dir, look_str)
	camera_target.update()
	player.look_at(look_dir)
	player.update_trajectory_direction()
	
	if charging_shot:
		if input["controls"]["shoot_released"]:
			_stop_charging()
			return
		_update_charging()
		return

	if input["controls"]["interact"] and input["interaction"]:
		emit_signal("finished", "PlayerInteracting")
		return
	elif input["controls"]["shoot_pressed"]:
		_start_charging()
	.update(input)

func _start_charging():
	emit_signal("player_started_charging_shot")
	player.set_hit_strength(0.0)
	camera.set_zoom_level("far")
	charging_shot = true

func _update_charging():
	shot_charge += shot_charge_dir * SHOT_CHARGE_SPEED * get_physics_process_delta_time()
	if shot_charge <= 0:
		shot_charge = 0.0
		shot_charge_dir = 1
	elif shot_charge >= 1:
		shot_charge = 1.0
		shot_charge_dir = -1
	var shot_charge_eased = Easing.Quad.easeInOut(shot_charge, 0.0, 1.0, 1.0)
	player.set_hit_strength(shot_charge_eased)
	
func _stop_charging():
	emit_signal("player_stopped_charging_shot")
	player.shoot()
	emit_signal("finished", "PlayerMoving")
