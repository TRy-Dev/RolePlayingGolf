extends RigidBody2D

# Seems to not be the way, as RigidBody2D movement can't be easily adjusted 
# to be similar to PhysicalObject2D (can be done, but would require rewriting
# physics code, which is already done in PhysicalObject2D)

onready var trajectory = $TrajectoryLine

export(float, 10.0, 1000.0) var hit_min_force = 20.0
export(float, 10.0, 1000.0) var hit_max_force = 390.0

var current_hit_strength = 1.0

const STRENGTH_CHANGE_SPEED = 1.5
const STRENGTH_STEP = 1.0 / 12.0

var direction = Vector2.RIGHT setget set_direction

func _ready():
	trajectory.set_shape($CollisionShape2D.shape)

func shoot() -> void:
	AudioController.sfx.play("hit")
	var force = direction * lerp(hit_min_force, hit_max_force, current_hit_strength)
	apply_central_impulse(force)

func set_direction(dir: Vector2) -> void:
	direction = dir.normalized()

func update_trajectory_direction(dir: Vector2) -> void:
	trajectory.set_direction(direction)

func update_hit_strength(dir: int):
	if not dir in [-1, 1, 0]:
		push_error("Incorrect player force change direction: %s" % dir)
		return
	current_hit_strength += dir * STRENGTH_STEP
	current_hit_strength = clamp(current_hit_strength, 0.0, 1.0)

func _on_body_entered(body):
	AudioController.sfx.play("wall_hit")
