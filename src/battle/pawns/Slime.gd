extends Pawn

const SPEED_MULT = 0.5

func _on_Area2D_body_entered(body: Node) -> void:
	body.mult_velocity(SPEED_MULT)
	Console.log_msg("Yuck!")
	_destroy()

func _on_Area2D_area_entered(area: Area2D) -> void:
	_destroy()

#func get_state():
#	return {}
#
#func set_state():
#	return
