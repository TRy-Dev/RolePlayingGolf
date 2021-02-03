extends Node

signal turn_changed(turn)

const GAME_SAVE_ID = 1

# Global State Variables
var turn := 0

func initialize(player: Player, world: GridWorld) -> void:
	player.connect("moved", self, "_on_player_moved")

func save_state() -> void:
	GameSaver.save_game(GAME_SAVE_ID)

func load_state() -> void:
	GameSaver.load_game(GAME_SAVE_ID)

func save_global_state(save: Resource) -> void:
	save.data["global"] = {}
	save.data["global"]["turn"] = turn

func load_global_state(save: Resource) -> void:
	turn = save.data["global"]["turn"]
	emit_signal("turn_changed", turn)

func _on_player_moved():
	turn += 1
	emit_signal("turn_changed", turn)
