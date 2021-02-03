extends Area2D

class_name Interaction

signal started()
signal finished()

func start() -> void:
	print("start interaction: %s" %name)
	emit_signal("started")
