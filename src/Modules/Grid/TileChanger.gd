extends Node2D

var _toggles = []

export(int) var tile_id_on
export(int) var tile_id_off

var tile_pos
var _world

func init(world, toggles) -> void:
	_toggles = toggles
	_world = world
	for t in _toggles:
		t.connect("state_changed", self, "_toggle_state_changed")
	tile_pos = _world.env_world_to_map(global_position)
	_toggle_state_changed("value is not used")

func _toggle_state_changed(value):
	var enabled_count = 0
	for t in _toggles:
		if t.enabled:
			enabled_count += 1
	if enabled_count == len(_toggles) and tile_id_on > -2:
		_world.set_env_tile(tile_pos, tile_id_on)
	elif tile_id_off > -2:
		_world.set_env_tile(tile_pos, tile_id_off)
