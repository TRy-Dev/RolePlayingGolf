extends Node2D

onready var pivot = $Pivot
onready var charge = $Pivot/Arrow/Charge
onready var brute_charge = $Pivot/Arrow/BruteCharge
onready var anim_player = $AnimationPlayer

var _cursor_visible = false

const MIN_STR_VAL = 0.255
const MAX_STR_VAL = 0.8
var range_len = MAX_STR_VAL - MIN_STR_VAL

func _ready() -> void:
	show()

func rotate(value) -> void:
	pivot.rotation_degrees = rad2deg(value)

func set_strength_percent(percent):
	if percent > 1.0:
		_show_brute_strength(percent - 1.0)
		percent = 1.0
	else:
		_show_brute_strength(0.0)
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

func _show_brute_strength(percent):
	var range_len = MAX_STR_VAL - MIN_STR_VAL
	var val = MIN_STR_VAL + percent * range_len
	brute_charge.material.set_shader_param("value", val)
