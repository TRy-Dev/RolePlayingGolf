extends KinematicBody2D

# Base class for collision interaction and/or detection with other objects
# Create inherited scene with inheriting script to create custom behaviour
# Area uses the same physics layers as kinematic body (set in _ready)

class_name DynamicCollider

export(bool) var collide := true
export(bool) var detect_collisions := true

onready var physics_collider = $CollisionShape2D
onready var area = $Area2D
onready var area_collider = $Area2D/CollisionShape2D

func _ready():
	# Get rid of unused colliders
	if detect_collisions:
		area.collision_layer = collision_layer
	else:
		area.queue_free()
	if not collide:
		physics_collider.queue_free()

func set_disabled(collision_disabled: bool, area_disabled: bool) -> void:
	if collide:
		physics_collider.disabled = collision_disabled
	if detect_collisions:
		area_collider.disabled = area_disabled

func _on_body_entered(body):
	pass

func _on_body_exited(body):
	pass
