extends Node2D

onready var pivot = $Pivot
onready var charge = $Pivot/Arrow/Charge

func rotate(value) -> void:
	pivot.rotation_degrees = rad2deg(value)


const MIN_STR_VAL = 0.255
const MAX_STR_VAL = 0.8
var range_len = MAX_STR_VAL - MIN_STR_VAL
func set_strength_percent(percent):
	var val = MIN_STR_VAL + percent * range_len
	charge.material.set_shader_param("value", val)
