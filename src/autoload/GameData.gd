extends Node

var _states = {
	"checkpoint": {
	},
	"event": {
	}
}

var _player_state = {
	"exp": 0,
	"gold": 0,
}

var world_scene = preload("res://src/world/World.tscn")

var state_name_to_load = ""

func save_state(state_name):
	var world = get_parent().get_node("World")
	if not state_name in _states:
		print("State does not exist: %s" % state_name)
		return
	print("save state in %s" % state_name)
	if world:
		_states[state_name] = world.get_world_state()
#	_states[state_name]["log"] = Console.get_log_state()

func load_state(state_name):
	var world = get_parent().get_node("World")
	if not state_name in _states:
		print("State does not exist: %s" % state_name)
		return
	if not _states[state_name]:
		print("State exists but is empty: %s" % state_name)
		return
	print("load state from %s" % state_name)
	if world:
		world.set_world_state(_states[state_name])
#	Console.set_log_state(_states[state_name]["log"])
	state_name_to_load = ""

func load_world_with_state(state_name) -> void:
	if not state_name in _states:
		print("State does not exist: %s" % state_name)
		return
	state_name_to_load = state_name
	MusicPlayer.set_music_volume(-80, Courtain.anim_length)
	yield(Courtain.show(), "completed")
	get_tree().change_scene_to(world_scene)
#	load_state(state_name)

func update_player_state(state_name, delta) -> bool:
	if not state_name in _player_state:
		print("Unknown player state: %s" % state_name)
		return false
	if _player_state[state_name] + delta < 0:
		print("not enough %s (%s) to remove %s" % \
				[state_name, _player_state[state_name], delta])
		return false
	_player_state[state_name] += delta
	print("Player %s updated to %s (%s)" % \
			[state_name, _player_state[state_name], delta])
	return true
