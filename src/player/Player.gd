extends TopDownCharacter

onready var trajectory = $TrajectoryLine

export(float, 10.0, 1000.0) var hit_min_force = 20.0
export(float, 10.0, 1000.0) var hit_max_force = 390.0

var current_hit_strength = 1.0

const STRENGTH_STEP = 1.0 / 1.0 #12.0

var direction = Vector2.RIGHT

func _ready():
	trajectory.set_shape($CollisionShape2D.shape)

func shoot() -> void:
	AudioController.sfx.play("hit")
	var force = direction * lerp(hit_min_force, hit_max_force, current_hit_strength) * Engine.iterations_per_second
	apply_force(force)

func look_at(dir: Vector2) -> void:
	direction = dir.normalized()

func update_trajectory_direction(dir: Vector2) -> void:
	trajectory.set_direction(direction)

func update_hit_strength(dir: int):
	if not dir in [-1, 1, 0]:
		push_error("Incorrect player force change direction: %s" % dir)
		return
	current_hit_strength += dir * STRENGTH_STEP
	current_hit_strength = clamp(current_hit_strength, 0.0, 1.0)

func _handle_collision(collision):
	var angle_deg = rad2deg(collision.normal.angle())
#	if not Math.is_vector_cardinal(collision.normal):
#		print(angle_deg)
	AudioController.sfx.play("wall_hit")
	._handle_collision(collision)
