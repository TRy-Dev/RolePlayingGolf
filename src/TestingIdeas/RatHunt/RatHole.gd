extends Node2D

signal destroyed(hole)

export(float, 0.0, 1.0) var collision_velocity_multiplier = 0.9

onready var anim_player = $AnimationPlayer

var grid_position = null

func initialize(grid_pos: Vector2) -> void:
	grid_position = grid_pos
	global_position = GlobalConstants.grid_to_world(grid_pos)

func _ready():
#	AnimationController.play(anim_player, "unburrow")
	pass

func _on_Area2D_body_entered(body):
	if body is Player:
		body.multiply_velocity(collision_velocity_multiplier)
		emit_signal("destroyed", self)
		queue_free()
