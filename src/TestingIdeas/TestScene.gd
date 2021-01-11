extends Node2D

onready var player = $Player
onready var camera = $CameraController
onready var camera_target = $Player/CameraTarget

var area_start := Vector2()
var area_end := Vector2()

func _ready():
	$Hole.connect("player_entered", self, "_on_player_entered_hole")
	camera.set_target_instant(camera_target)
	var center = $TargetArea.global_position
	var extents = $TargetArea.shape.extents
	area_start = center - extents
	area_end = center + extents

func _process(delta) -> void:
	handle_input()

func _physics_process(delta) -> void:
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
#	var str_change = Input.get_action_strength("up") - Input.get_action_strength("down")
#	if abs(str_change) < Math.EPSILON:
#		str_change = int(Input.is_action_just_pressed("scroll_up")) - int(Input.is_action_just_pressed("scroll_down"))
	var change_direction = int(Input.is_action_just_released("scroll_up")) - int(Input.is_action_just_released("scroll_down"))
	player.update_hit_strength(change_direction)

func update_player_is_shooting() -> void:
	if Input.is_action_just_pressed("fire") or Input.is_action_just_pressed("click"):
		player.shoot()

func handle_debug_input() -> void:
	if Input.is_action_just_pressed("debug_restart"):
		SceneController.reload_current()

func _on_player_entered_hole(t) -> void:
	var new_pos = Rng.randv(area_start, area_end)
	t.global_position = new_pos
