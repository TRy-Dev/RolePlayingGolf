extends Node2D


onready var cam_controller = get_parent().get_parent()
onready var coll = $Area2D/CollisionShape2D

#var center
#
#func _ready() -> void:
#	center = global_position
func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player":
		cam_controller.look_at_room(global_position, 2 * coll.shape.extents)
