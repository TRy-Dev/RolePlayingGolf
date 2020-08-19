extends Node2D

onready var camera = $Camera2D
onready var tween = $Tween

const PADDING = Vector2(32, 32)

func _ready() -> void:
	camera.smoothing_enabled = false

func look_at_room(pos, size) -> void:
	camera.global_position = pos
	size += PADDING
	var zoom = size / get_viewport_rect().size
	
	zoom.x = max(zoom.x, zoom.y)
	zoom.y = max(zoom.x, zoom.y)
	
	tween.interpolate_property(camera, "zoom",
		camera.zoom, zoom, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	camera.smoothing_enabled = true
