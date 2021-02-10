extends Node

var rats_to_kill = 0
var rats_killed = 0

const RAT_INDEX = 1
const STORY_RATS_VARIABLE = "killed_rats"

func _on_pawn_created(idx, pos) -> void:
	if idx == RAT_INDEX:
		rats_to_kill += 1
#		print("Rat added %s" %rats_to_kill)

func _on_pawn_destroyed(idx, pos) -> void:
	if idx == RAT_INDEX:
		rats_killed += 1
#		print("Rat killed %s / %s" %[rats_killed, rats_to_kill])
		if rats_killed >= rats_to_kill:
			AudioController.sfx.play("goal")
			DialogueController.set_variable(STORY_RATS_VARIABLE, true)
