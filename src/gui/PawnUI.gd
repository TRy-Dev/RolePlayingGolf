extends TextureRect

onready var tween = $Tween

export(Texture) var img_on = null
export(Texture) var img_off = null

export(String) var color_on = "white"
export(String) var color_off = "red"

var COLOR_ON
var COLOR_OFF

func _ready() -> void:
	COLOR_ON = Colors.get_color(color_on)
	COLOR_OFF = Colors.get_color(color_off)
	modulate = COLOR_ON
	

func set_enabled(value) -> void:
	tween.stop_all()
	if value:
		texture = img_on
		set_color(COLOR_ON)
	else:
		texture = img_off
		set_color(COLOR_OFF)

func set_color(col) -> void:
	tween.stop_all()
	tween.interpolate_property(self, "modulate" , modulate, col, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
