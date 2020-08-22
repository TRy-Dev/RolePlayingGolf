extends Node

onready var music :AudioStreamPlayer = $Music
onready var tween :Tween = $Tween

const VOLUME_CHANGE_TIME = 1.0

const BASE_VOLUME = -8

var songs = {
	"world": preload("res://assets/music/world.ogg"),
	"battle": preload("res://assets/music/battle.ogg"),
	"dialog": preload("res://assets/music/dialog_scene.ogg"),
	"main-menu": preload("res://assets/music/main_menu.ogg"),
}
func _ready() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), BASE_VOLUME)
	music.volume_db = -80

func play_song(title) -> void:
	if not title in songs:
		print("--- Song not recognized: %s" % title)
		return
	music.stream = songs[title]
	music.play()
	set_music_volume(0, VOLUME_CHANGE_TIME)

func set_music_volume(value, time) -> void:
	tween.stop_all()
	tween.interpolate_property(music, "volume_db", music.volume_db, value, time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
