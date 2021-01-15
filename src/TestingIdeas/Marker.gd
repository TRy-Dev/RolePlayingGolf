extends Sprite

onready var dir_line = $Direction
onready var label = $Label

const LINE_LENGTH = 10

func set_direction(dir: Vector2) -> void:
	dir_line.points[1] = dir.normalized() * LINE_LENGTH

func set_text(text: String) -> void:
	label.text = text
