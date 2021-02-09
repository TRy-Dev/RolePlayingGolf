extends Area2D

class_name Interaction

signal started()
signal finished()

var active = false

func start() -> void:
	active = true
	emit_signal("started")
	# TEMP - so that player is behind interaction obiect and UI when its active
	get_parent().z_index = 20

func finish() -> void:
	active = false
	emit_signal("finished")
	# TEMP - so that player is behind interaction obiect and UI when its active
	get_parent().z_index = 0

func get_interaction_target():
	return $InteractionCenter

func get_interaction_owner():
	return get_parent()
