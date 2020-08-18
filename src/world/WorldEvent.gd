extends Node2D

class_name WorldEvent

var enabled = true

func _on_Area2D_body_entered(body: Node) -> void:
	print("player entered event")
