extends Pawn


func _ready() -> void:
	._ready()

func move():
	# assumption: has valid target
#	if not target or not is_instance_valid(target):
#		target = owner.get_closest_heart(global_position, target)
#	if not target:
#		return self
	yield(.move(), "completed")

func find_target() -> bool:
	target = owner.get_closest_heart(global_position)
	if target:
		return true
	return false

func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player":
		_destroy()

func _on_target_destroyed(t) -> void:
	target = owner.get_closest_heart(global_position, t)
