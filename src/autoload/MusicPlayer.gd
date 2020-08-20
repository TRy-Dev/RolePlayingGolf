extends Node

onready var music :AudioStreamPlayer = $Music
onready var tween :Tween = $Tween

var songs = {
	"world": preload("res://assets/music/world.ogg"),
	"battle": preload("res://assets/music/battle.ogg"),
	"dialog": preload("res://assets/music/dialog_scene.ogg"),
	"main-menu": preload("res://assets/music/main_menu.ogg"),
}
func _ready() -> void:
	music.volume_db = -80

func play_song(title) -> void:
	if not title in songs:
		print("--- Song not recognized: %s" % title)
		return
	music.stream = songs[title]
	music.play()
	set_music_volume(0, 1.0)

func set_music_volume(value, time) -> void:
	tween.stop_all()
	tween.interpolate_property(music, "volume_db", music.volume_db, value, time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
