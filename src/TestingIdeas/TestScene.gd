extends Node2D

onready var player = $Player
onready var camera = $CameraController
onready var camera_target = $Player/CameraTarget

func _ready():
	camera.set_target_instant(camera_target)

func _process(delta) -> void:
	handle_input()

func _physics_process(delta) -> void:
	var dir = (get_global_mouse_position() - player.global_position).normalized()
	player.update_trajectory_direction(dir)
	player.update()

func handle_input() -> void:
	update_player_look_direction()
	update_player_hit_strength()
	update_player_is_shooting()
	handle_debug_input()

func update_player_look_direction() -> void:
	var dir = (get_global_mouse_position() - player.global_position).normalized()
	camera_target.set_offset(dir, 1.0)
	camera_target.update()
	player.look_at(dir)

func update_player_hit_strength() -> void:
	var change_direction = int(Input.is_action_just_released("scroll_up")) - int(Input.is_action_just_released("scroll_down"))
	player.update_hit_strength(change_direction)

func update_player_is_shooting() -> void:
	if Input.is_action_just_pressed("fire") or Input.is_action_just_pressed("click"):
		player.shoot()

func handle_debug_input() -> void:
	if Input.is_action_just_pressed("debug_restart"):
		SceneController.reload_current()
