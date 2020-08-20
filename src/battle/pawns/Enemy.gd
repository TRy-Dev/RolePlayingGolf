extends Pawn


func _ready() -> void:
	._ready()

func move() -> void:
	if not target or not is_instance_valid(target):
		target = owner.get_closest_heart(global_position, target)
	yield(.move(), "completed")

func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player":
		print("destroyed by player")
		_destroy()

func _on_target_destroyed(t) -> void:
	print("target_was_destroyed")
	target = owner.get_closest_heart(global_position, t)
