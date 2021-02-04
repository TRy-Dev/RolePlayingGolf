extends Node2D

signal game_paused(value)

onready var world = $GridWorld
onready var player = $Player
onready var camera = $CameraController
onready var camera_target = $Player/CameraTarget
onready var gui = $GUI
onready var fsm = $GameStateMachine

const PLAYER_MOVE_TIME = 1.5

var pausable_nodes = []

func _ready():
	pausable_nodes = [
		world, player, camera, camera_target,
	]
	GlobalState.initialize(player, world)
	fsm.connect("state_changed", $CanvasLayer/StateNameDisplay, "_on_state_changed")
	fsm.initialize()
	gui.initialize(player, world)
	camera.set_target_instant(camera_target)
	camera.set_zoom(0.3, false)
	camera.set_zoom(0.25)
	player.connect("died", self, "_on_player_died")
#	AudioController.music.play("world")

func _physics_process(delta):
	var mouse_player_vector = get_global_mouse_position() - player.global_position
	var look_strength = Math.map(mouse_player_vector.length(), 0.0, 100, 0.0, 1.0)
	var input = {
		"controls": {
			"look_direction": mouse_player_vector.normalized(),
			"look_strength": look_strength,
			"shoot_pressed": Input.is_action_just_pressed("click"),
			"shoot_released": Input.is_action_just_released("click"),
			"interact": Input.is_action_just_pressed("interact"),
			"pause": Input.is_action_just_pressed("pause")
		},
		"world": world,
		"player": player,
		"camera": camera,
		"camera_target": camera_target,
		"gui": gui,
	}
	fsm.update(input)
	
	if Input.is_action_just_pressed("debug_restart"):
		SceneController.reload_current()
		DebugOverlay.clear_stats()
		GlobalState.reset()

func save_state(save: Resource):
	GlobalState.save_global_state(save)
	player.save_state(save)
	world.save_state(save)
	
func load_state(save: Resource):
	GlobalState.load_global_state(save)
	player.disable_collisions(true)
	world.load_state(save)
	player.load_state(save)
	# Wait for collision disabling to kick-in, 
	# otherwise tiles under player old position will collide with them
	yield(get_tree().create_timer(0.2), "timeout")
	player.disable_collisions(false)

func _on_player_died():
	print("Player died, should load last save state")

### Testing
#func simulate_random_turn() -> void:
#	var angle_rad = Rng.randf(0.0, 2 * PI)
#	var dir = Vector2(cos(angle_rad), sin(angle_rad))
#	player.update_trajectory_direction(dir)
#	camera_target.set_offset(dir, 1.0)
#	camera_target.update()
#	player.direction = dir
#	player.shoot()
#	yield(get_tree().create_timer(PLAYER_MOVE_TIME), "timeout")
#	world.update_pawns()

#func _on_TurnTimer_timeout():
#	simulate_random_turn()

##### TEMPORARY
func set_player_trajectory_visible(val: bool) -> void:
	player.set_trajectory_visible(val)

func set_pause_game(val: bool) -> void:
	for node in pausable_nodes:
		node.pause_mode = Node.PAUSE_MODE_INHERIT if val else Node.PAUSE_MODE_STOP
	emit_signal("game_paused", val)

func reset_camera_target() -> void:
	camera_target.force_reset_offset()
