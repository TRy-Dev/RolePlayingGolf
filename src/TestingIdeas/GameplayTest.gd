extends Node2D

onready var world = $GridWorld
onready var player = $Player
onready var camera = $CameraController
onready var camera_target = $Player/CameraTarget

const PLAYER_MOVE_TIME = 1.5

func _ready():
	camera.set_target_instant(camera_target)
	camera.set_zoom(0.3, false)
	camera.set_zoom(0.25)
	$TurnTimer.wait_time = PLAYER_MOVE_TIME + GlobalConstants.MOVE_TIME
#	$TurnTimer.start()
	AudioController.music.play("world")

func _process(delta):
	if Input.is_action_just_pressed("click"):
		player.shoot()
		yield(get_tree().create_timer(PLAYER_MOVE_TIME), "timeout")
		world.update_pawns()
	update_direction()
	update_hit_strength()
	if Input.is_action_just_pressed("debug_restart"):
		SceneController.reload_current()
		DebugOverlay.clear_stats()
	if Input.is_action_just_pressed("save_game_state"):
		_save_game()
	if Input.is_action_just_pressed("load_game_state"):
		_load_game()
	
	world.update_player_position(player.global_position)

func _physics_process(delta) -> void:
	var dir = (get_global_mouse_position() - player.global_position).normalized()
	player.update_trajectory_direction(dir)
	player.update()

func update_direction() -> void:
	var dir = (get_global_mouse_position() - player.global_position).normalized()
	camera_target.set_offset(dir, 1.0)
	camera_target.update()
	player.direction = dir

func update_hit_strength() -> void:
	var change_direction = int(Input.is_action_just_released("scroll_up")) - int(Input.is_action_just_released("scroll_down"))
	player.update_hit_strength(change_direction)

func simulate_random_turn() -> void:
	var angle_rad = Rng.randf(0.0, 2 * PI)
	var dir = Vector2(cos(angle_rad), sin(angle_rad))
	player.update_trajectory_direction(dir)
	camera_target.set_offset(dir, 1.0)
	camera_target.update()
	player.direction = dir
	player.shoot()
	yield(get_tree().create_timer(PLAYER_MOVE_TIME), "timeout")
	world.update_pawns()

func _on_TurnTimer_timeout():
	simulate_random_turn()

func _save_game():
	print("save")
	
func _load_game():
	print("load")
