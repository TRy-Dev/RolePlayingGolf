extends Node

signal player_state_updated

var _states = {
	"checkpoint": {
	},
	"event": {
	}
}

const START_MAX_PLAYER_MOVES = 1
var max_player_moves = START_MAX_PLAYER_MOVES

const START_PLAYER_STATE = {
	"exp": 0,
	"gold": 0,
	"moves": START_MAX_PLAYER_MOVES
}
var _player_state = START_PLAYER_STATE

var world_scene = preload("res://src/world/World.tscn")

var state_name_to_load = ""

var _skills = {
	"break": {
		"ui-name": "-Control",
		"description": "Press space to break while moving",
		"unlocked": true
	},
	"seer": {
		"ui-name": "Seer",
		"description": "See Golfs' path when aiming",
		"unlocked": false
	},
	"side-control": {
		"ui-name": "Acrobat",
		"description": "Press left/right to steer while moving",
		"unlocked": false
	},
	"force": {
		"ui-name": "Brute",
		"description": "Increased maximum movement force",
		"unlocked": false
	},
	"extra-move": {
		"ui-name": "-Extra move",
		"description": "Additional move and heart",
		"unlocked": false
	},
}

func _ready():
	load_default_state(true)

func save_state(state_name, save_velocity = true):
	var world = get_parent().get_node("World")
	if not state_name in _states:
		print("State does not exist: %s" % state_name)
		return
	print("save state in %s" % state_name)
	if world:
		_states[state_name] = world.get_world_state(save_velocity)
	_states[state_name]["player-state"] = {}
	if state_name == "checkpoint":
		for s in _player_state:
			_states[state_name]["player-state"][s] = _player_state[s]
		_states[state_name]["skills"] = _skills.duplicate(true)
#	_states[state_name]["log"] = Console.get_log_state()

func load_state():
	var state_name = state_name_to_load
	if not state_name:
		return
	var world = get_parent().get_node("World")
	if not state_name in _states:
		print("State does not exist: %s" % state_name)
		return
	if not _states[state_name]:
		print("State exists but is empty: %s. Loading default" % state_name)
		load_default_state(true)
		return
	print("load state from %s" % state_name)
	if world:
		world.set_world_state(_states[state_name])
	if state_name == "checkpoint":
		var player_pers_state = _states[state_name]["player-state"]
		for s in player_pers_state:
			set_player_state(s, player_pers_state[s])
		set_player_state("moves", max_player_moves)
		_skills = _states[state_name]["skills"]
#	Console.set_log_state(_states[state_name]["log"])
	state_name_to_load = ""

func load_default_state(reset_saved_states):
	print("loading default state")
	max_player_moves = START_MAX_PLAYER_MOVES
	_player_state = START_PLAYER_STATE
	for s in _player_state:
		set_player_state(s, _player_state[s])
	if reset_saved_states:
		_states = {
			"checkpoint": {
		},
			"event": {
		}
}
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

func set_player_state(state_name, value) -> void:
	if not state_name in _player_state:
		print("Unknown player state: %s" % state_name)
		return
	_player_state[state_name] = value
	emit_signal("player_state_updated", state_name, _player_state[state_name])
	print("Player %s set to %s" % \
			[state_name, value])

func update_player_state(state_name, delta) -> bool:
	if not state_name in _player_state:
		print("Unknown player state: %s" % state_name)
		return false
	if state_name != "moves" and _player_state[state_name] + delta < 0:
		print("not enough %s (%s) to remove %s" % \
				[state_name, _player_state[state_name], delta])
		return false
	_player_state[state_name] += delta
	emit_signal("player_state_updated", state_name, _player_state[state_name])
	print("Player %s updated to %s (%s%s)" % \
			[state_name, _player_state[state_name], "" if delta < 0 else "+", delta])
	return true

func get_player_state(state_name):
	if not state_name in _player_state:
		print("Unknown player state: %s" % state_name)
		return null
	return _player_state[state_name]

func get_player_state_all():
	return _player_state

func reset_moves():
	set_player_state("moves", max_player_moves)

func decrease_moves(amount :int = 1):
	update_player_state("moves", -amount)

func get_hearts_count() -> int:
	if _player_state["moves"] >= 0:
		return max_player_moves
#	return -1 * _player_state["moves"]
	return int(max(1, max_player_moves  + _player_state["moves"]))

func unlock_skill(skill_name) -> void:
	if not skill_name in _skills:
		print("--- Skill not found: %s" % skill_name)
		return
	_skills[skill_name]["unlocked"] = true

func skill_unlocked(skill_name) -> bool:
	if not skill_name in _skills:
		return false
	return _skills[skill_name]["unlocked"]

func get_unlocked_skills() -> Dictionary:
	var unlocked = {}
	for s in _skills:
		if s["unlocked"]:
			unlocked[s] = _skills[s]
	return unlocked
