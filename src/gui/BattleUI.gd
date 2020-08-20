extends Control

onready var main_text = $CanvasLayer/MainText

func set_main_text(value) -> void:
	main_text.text = value

func _on_turn_step_changed(previous, next) -> void:
	if main_text:
		main_text.text = next
