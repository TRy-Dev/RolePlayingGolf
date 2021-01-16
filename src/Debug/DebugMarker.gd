extends Node2D

onready var dir_line = $Direction
onready var label = $Label

const LINE_LENGTH = 10

func set_direction(dir: Vector2) -> void:
	dir_line.points[1] = dir.normalized() * LINE_LENGTH
	if not Math.is_vector_cardinal(dir):
		label.text = str(stepify(rad2deg(dir.angle()), 1))

func set_text(text: String) -> void:
	pass
#	label.text = text
