extends TextureRect

onready var tween = $Tween

export(Texture) var heart_on = null
export(Texture) var heart_off = null

const COLOR_ON = Color(1,1,1,1)
const COLOR_OFF = Color("e6482e")

func _ready() -> void:
	modulate = COLOR_ON

func set_enabled(value) -> void:
	tween.stop_all()
	if value:
		texture = heart_on
		tween.interpolate_property(self, "modulate" , modulate, COLOR_ON, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()
	else:
		texture = heart_off
		tween.interpolate_property(self, "modulate", modulate, COLOR_OFF, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()
