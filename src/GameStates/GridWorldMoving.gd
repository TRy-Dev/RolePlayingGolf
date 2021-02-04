extends GameState

var started_updating = false
var pause_after_moving = false

func enter(previous: State) -> void:
	started_updating = false
	pause_after_moving = false

func update(input: Dictionary) -> void:
	var player = input["player"]
	var world = input["world"]
	
	if world.is_updating_tiles:
		if input["controls"]["pause"]:
			pause_after_moving = true
		return
	elif started_updating:
		emit_signal("finished", "WaitingForPlayerInput")
		if pause_after_moving:
			emit_signal("finished", "GamePaused")
		return
	started_updating = true
	world.update_player_position(player.global_position)
	world.update_tiles()
	.update(input)
