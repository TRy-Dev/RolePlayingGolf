extends Control

var heart_ui_prefab = preload("res://src/gui/HeartUI.tscn")
onready var heart_container = $CanvasLayer/UI/Hearts/HeartContainer
var hearts = []

onready var moves_label = $CanvasLayer/UI/Moves
onready var gold_label = $CanvasLayer/UI/Gold
onready var exp_label = $CanvasLayer/UI/Exp

func _ready() -> void:
	GameData.connect("player_state_updated", self, "_on_player_state_updated")
#	for i in range(GameData.max_player_moves):
#		var heart_ui = heart_ui_prefab.instance()
#		heart_ui.call_deferred("set_enabled", true)
#		hearts.append(heart_ui)
#		heart_container.add_child(heart_ui)
	_update_hearts()
	moves_label.text = "Moves: %s/%s" % [GameData.get_player_state("moves"), GameData.max_player_moves]
	owner.connect("scene_ready", self, "_update_all")
	_update_all()

func _on_player_state_updated(state, value) -> void:
	match state:
		"moves":
			moves_label.text = "Moves: %s/%s" % [value, GameData.max_player_moves]
			_update_hearts()
		"gold":
			gold_label.text = "Gold: %s" % value
		"exp":
			exp_label.text = "Exp: %s" % value

func _update_all():
	var player_state = GameData.get_player_state_all()
	for s in player_state:
		_on_player_state_updated(s, player_state[s])

func _update_hearts():
	for i in range(GameData.max_player_moves - len(hearts)):
		var heart_ui = heart_ui_prefab.instance()
		heart_ui.call_deferred("set_enabled", true)
		hearts.append(heart_ui)
		heart_container.add_child(heart_ui)
	var h_count = GameData.get_hearts_count()
	for i in range(len(hearts)):
		hearts[i].set_enabled(true)
	for i in range(len(hearts) - h_count):
		hearts[len(hearts) - 1 - i].set_enabled(false)
