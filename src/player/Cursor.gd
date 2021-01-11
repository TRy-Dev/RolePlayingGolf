extends Node2D

onready var pivot = $Pivot
onready var charge = $Pivot/Charge

func set_rotation(value: float) -> void:
	pivot.rotation_degrees = value

func set_value(value: float) -> void:
	charge.material.set_shader_param("value", clamp(value, 0.0, 1.0))
