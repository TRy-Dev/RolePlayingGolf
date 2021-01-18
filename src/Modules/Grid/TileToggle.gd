extends Node2D

signal state_changed

export var pawn_id = 0
export(bool) var hidden = false

# active/not-active
var enabled = false

func _ready() -> void:
	visible = not hidden

func pawn_entered(id) -> void:
	if id == pawn_id:
		_change_state(true)

func pawn_exited(id) -> void:
	_change_state(false)

func _change_state(value) -> void:
	enabled = value
	emit_signal("state_changed", value)
