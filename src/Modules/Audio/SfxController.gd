extends Node

onready var _sources_0d = $Sources
onready var _sources_2d = $Sources2D

var _clips := {}

const MAX_AUDIO_SOURCES := 4
const MIN_PITCH := 0.8
const MAX_PITCH := 1.2
const SFX_PATH := "res://assets/audio/sfx"

func _init():
	self.load()

func play(name: String) -> void:
	if not name in _clips:
		push_error("HEY! No such audio clip: %s" %name)
		return
	var source = _get_idle_source(_sources_0d, AudioStreamPlayer)
	_play_audio(source, name)

func play_at(name: String, position: Vector2) -> void:
	if not name in _clips:
		push_error("HEY! No such audio clip: %s" %name)
		return
	var source = _get_idle_source(_sources_2d, AudioStreamPlayer2D)
	if source:
		source.global_position = position
		_play_audio(source, name)

func _get_idle_source(sources_parent, template):
	var sources = sources_parent.get_children()
	for source in sources:
		if not source.playing:
			return source
	if len(sources) < MAX_AUDIO_SOURCES:
		var new_source = template.new()
		new_source.bus = "Sfx"
		sources_parent.add_child(new_source)
		return new_source
	else:
		push_error("HEY! Trying to play more than %s audio clips at the same time" % MAX_AUDIO_SOURCES)

func _play_audio(source, name: String):
	if not source:
		return
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
