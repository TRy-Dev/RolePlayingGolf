extends TopDownCharacter

onready var cursor = $Cursor
onready var trajectory = $TrajectoryLine

export(float, 10.0, 1000.0) var hit_min_force = 20.0
export(float, 10.0, 1000.0) var hit_max_force = 390.0

var current_hit_strength = 0.0

const STRENGTH_CHANGE_SPEED = 1.5
const STRENGTH_STEP = 1.0 / 12.0

var direction = Vector2.RIGHT

func shoot() -> void:
	AudioController.sfx.play("hit")
	var force = direction * lerp(hit_min_force, hit_max_force, current_hit_strength) * Engine.iterations_per_second
	apply_force(force)

func look_at(dir: Vector2) -> void:
	direction = dir.normalized()
	trajectory.set_direction(direction)
	cursor.set_rotation(rad2deg(dir.angle()))

func update_hit_strength(dir: int):
	if not dir in [-1, 1, 0]:
		push_error("Incorrect player force change direction: %s" % dir)
		return
	current_hit_strength += dir * STRENGTH_STEP
	current_hit_strength = clamp(current_hit_strength, 0.0, 1.0)
	cursor.set_value(current_hit_strength)

func _handle_collision(collision):
	AudioController.sfx.play("wall_hit")
	._handle_collision(collision)
