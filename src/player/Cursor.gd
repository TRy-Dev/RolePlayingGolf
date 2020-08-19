extends Node2D

onready var pivot = $Pivot
onready var charge = $Pivot/Arrow/Charge
onready var anim_player = $AnimationPlayer

var _cursor_visible = false

func _ready() -> void:
	show()

func rotate(value) -> void:
	pivot.rotation_degrees = rad2deg(value)

func set_strength_percent(percent):
	var MIN_STR_VAL = 0.255
	var MAX_STR_VAL = 0.8
	var range_len = MAX_STR_VAL - MIN_STR_VAL
	var val = MIN_STR_VAL + percent * range_len
	charge.material.set_shader_param("value", val)

func show():
	if not _cursor_visible:
		anim_player.play("show")
		_cursor_visible = true
	
func hide():
	if _cursor_visible:
		anim_player.play("hide")
		_cursor_visible = false
