extends Node

# https://www.youtube.com/watch?v=_DAvzzJMko8

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

onready var camera = get_parent()
onready var shake_tween = $ShakeTween
onready var frequency_timer = $Frequency
onready var duration_timer = $Duration

var amplitude = 0

var shakes = {
	"small": [0.2, 15, 8],
	"medium": [0.3, 18, 12],
	"big": [0.3, 20, 16],
}

func shake_screen(shake_name):
	if not shake_name in shakes:
		return
	var s = shakes[shake_name]
	start(s[0], s[1], s[2])

func start(duration = 0.2, frequency = 15, amplitude = 16):
	self.amplitude = amplitude
	
	duration_timer.wait_time = duration
	frequency_timer.wait_time = 1.0 / float(frequency)
	duration_timer.start()
	frequency_timer.start()
	
	_new_shake()

func _new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)

	shake_tween.interpolate_property(camera, "offset", camera.offset, rand, frequency_timer.wait_time, TRANS, EASE)
	shake_tween.start()

func _reset():
	shake_tween.interpolate_property(camera, "offset", camera.offset, Vector2(), frequency_timer.wait_time, TRANS, EASE)
	shake_tween.start()
	
func _on_Frequency_timeout() -> void:
	_new_shake()


func _on_Duration_timeout() -> void:
	_reset()
	frequency_timer.stop()
