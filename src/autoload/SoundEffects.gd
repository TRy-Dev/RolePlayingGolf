extends Node

onready var audio_players = get_children()
var _clips = {
	"hit": [
		preload("res://assets/sfx/footstep_concrete_000.wav"),
		preload("res://assets/sfx/footstep_concrete_001.wav"),
		preload("res://assets/sfx/footstep_concrete_002.wav"),
	],
}

const MIN_PITCH = 0.8
const MAX_PITCH = 1.2

var rng = RandomNumberGenerator.new()

func _init() -> void:
	rng.randomize()
	
func play_audio(clip_name) -> void:
	if not clip_name in _clips:
		print("Audio clip does not exist: %s" % clip_name)
		return
	for p in audio_players:
		if not p.playing:
			p.stream = _clips[clip_name][rng.randi_range(0, len(_clips[clip_name]) - 1)]
			p.pitch_scale = rng.randf_range(MIN_PITCH, MAX_PITCH)
			p.play()
			return
	print("Not enough AudioStreamPlayers")
