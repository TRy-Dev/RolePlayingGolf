extends Node

onready var music = $MusicController
onready var sfx = $SfxController

func _ready():
	music.load()
	sfx.load()

func set_bus_volume(name :String , volume :int):
	var bus_idx = AudioServer.get_bus_index(name)
	if bus_idx > -1:
		volume = clamp(volume, -80, 0)
		AudioServer.set_bus_volume_db(bus_idx, volume)
	else:
		push_error("HEY! Bus %s does not exist." % name)
