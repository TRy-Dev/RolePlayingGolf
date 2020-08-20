extends Pawn

func _on_Area2D_body_entered(body: Node) -> void:
	_destroy()

func _on_Area2D_area_entered(area: Area2D) -> void:
	_destroy()
