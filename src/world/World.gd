extends Node2D

signal scene_ready

onready var env = $EnvironmentStatic
onready var events_parent = $Events
#onready var events = events_parent.get_children()ssssa
onready var player = $Player
onready var main_ui = $MainUI

func _ready() -> void:
	MusicPlayer.play_song("world")
	Courtain.hide()
	GameData.load_state()
	main_ui.toggle_moves(true)
	$Fog.visible = true
	player.connect("player_moved", self, "_on_player_moved")
	emit_signal("scene_ready")
	for e in events_parent.get_children():
		e.connect("world_event_reached", self, "_on_world_event_reached")

func _process(delta: float) -> void:
#	if not player.is_moving:
	player.handle_input()

func set_world_state(state) -> void:
	# tiles
	env.clear()
	for pos in state["tiles"].keys():
		var index = state["tiles"][pos]
		env.set_cellv(pos, index)
	# events
	var events = events_parent.get_children()
	for e in events:
		e.queue_free()
	for e in state["events"]:
		_add_event(e)
	# player
	player.global_position = state["player"]["position"]
	player.velocity = state["player"]["velocity"]

func get_world_state(save_player_velocity) -> Dictionary:
	var state = {}
	# tiles
	state["tiles"] = {}
	for pos in env.get_used_cells():
		state["tiles"][pos] = env.get_cellv(pos)
	# events
	state["events"] = []
	var events = events_parent.get_children()
	for e in events:
		var event_state = e.get_state()
		state["events"].append(event_state)
	# player
	state["player"] = {}
	state["player"]["position"] = player.global_position
	if save_player_velocity:
		state["player"]["velocity"] = player.velocity
	else:
		state["player"]["velocity"] = Vector2()
	return state

func _add_event(event_data):
	var new_event
	match event_data["type"]:
		"checkpoint":
			new_event = load("res://src/world/events/Checkpoint.tscn").instance()
		"scene":
			new_event = load("res://src/world/events/SceneEvent.tscn").instance()
		"update-state":
			new_event = load("res://src/world/events/UpdatePlayerStateEvent.tscn").instance()
		"unlock-skill":
			new_event = load("res://src/world/events/SkillUnlockEvent.tscn").instance()
		_:
			print("Unknown event type %s" % event_data["type"])
			return
	new_event.set_state(event_data)
	events_parent.add_child(new_event)
	new_event.enabled = event_data["enabled"]
	new_event.global_position = event_data["position"]
#	events.append(new_event)

func _on_player_moved() -> void:
	GameData.decrease_moves()
	
func _on_world_event_reached(event) -> void:
	print("Event %s reached" % event.event_type)
#	match event.event_type:
#		"checkpoint":
#			event.set_color("yellow")
#		"scene":
#			event.set_color("red")
	
