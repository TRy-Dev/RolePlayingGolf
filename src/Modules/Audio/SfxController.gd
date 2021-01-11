extends Node

onready var _audio_sources_container = $Sources

var _clips = {}

var _audio_sources = []

const MAX_AUDIO_SOURCES = 10

const MIN_PITCH = 0.8
const MAX_PITCH = 1.2

const SFX_PATH = "res://assets/audio/sfx"

func play(name) -> void:
	if name in _clips:
		for s in _audio_sources:
			if not s.playing:
				_play_audio(s, name)
				return
		if len(_audio_sources) < MAX_AUDIO_SOURCES:
			var new_source = AudioStreamPlayer.new()
			new_source.bus = "Sfx"
			_audio_sources_container.add_child(new_source)
			_audio_sources.append(new_source)
			_play_audio(new_source, name)
		else:
			push_error("HEY! Trying to play too many (More than %s) audio clips at the same time" % MAX_AUDIO_SOURCES)
	else:
		push_error("HEY! No such audio clip: %s" %name)

func _play_audio(source, name):
	source.stream = _clips[name][Rng.randi(0, len(_clips[name]) - 1)]
	source.pitch_scale = Rng.randf(MIN_PITCH, MAX_PITCH)
	source.play()

func load():
	for dir in FileSystem.get_directories(SFX_PATH):
		_clips[dir] = []
		for f in FileSystem.get_files(FileSystem.concat_path([SFX_PATH, dir])):
			if f.ends_with(".wav"):
				var clip = load(FileSystem.concat_path([SFX_PATH, dir, f]))
				_clips[dir].append(clip)
