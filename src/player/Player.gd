extends TopDownCharacter

class_name Player

signal moved()
signal health_changed(health)
signal stamina_changed(stamina)

onready var trajectory = $TrajectoryLine

export(float, 10.0, 1000.0) var hit_min_force = 20.0
export(float, 10.0, 1000.0) var hit_max_force = 390.0

const START_STAMINA = 4
const START_HEALTH = 3

var stamina := START_STAMINA
var health := START_HEALTH

const START_STEPS = 4
const STRENGTH_RESOLUTION := 12
const STRENGTH_STEP = 1.0 / STRENGTH_RESOLUTION

var current_hit_strength = STRENGTH_STEP * START_STEPS

var direction = Vector2.RIGHT

func _ready():
	trajectory.set_shape($CollisionShape2D.shape)
	# Calculation works somehow, but if properties are changed it might to be improved
	var max_distance = pow((1.0 - 4 * friction_coeff), 2.0) * hit_max_force / mass * 0.5 
	var min_distance = pow((1.0 - 4 * friction_coeff), 2.0) * hit_min_force / mass * 0.5
	trajectory.set_line_length(min_distance, max_distance)
	update_hit_strength(0)

func shoot() -> void:
	stamina -= 1
	if stamina < 0:
		stamina = 0
		damage(1)
	emit_signal("stamina_changed", stamina)
	AudioController.sfx.play("hit")
	var force = direction * lerp(hit_min_force, hit_max_force, current_hit_strength)
	apply_force(force)
	emit_signal("moved")

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
	trajectory.update_line_length(current_hit_strength)

func _handle_collision(collision):
	AudioController.sfx.play_at("wall_hit", collision.position)
	._handle_collision(collision)

func apply_velocity(vel):
	apply_force(_vel_to_force(vel))

func multiply_velocity(mult):
	velocity *= mult

func damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		print("Health=0. Player should die!")
	emit_signal("health_changed", health)

func save_state(save):
	# Reset moves on save
	stamina = START_STAMINA
	emit_signal("stamina_changed", stamina)
	save.data["player"] = {}
	save.data["player"]["position"] = global_position
	save.data["player"]["velocity"] = velocity
	save.data["player"]["stamina"] = stamina
	save.data["player"]["health"] = health

func load_state(save):
	velocity = Vector2.ZERO #save.data["player"]["velocity"]
	stamina = save.data["player"]["stamina"]
	health = save.data["player"]["health"]
	# set position last as it will trigger save (BUG)
	global_position = save.data["player"]["position"]
	emit_signal("stamina_changed", stamina)
	emit_signal("health_changed", health)

func disable_collisions(value: bool) -> void:
	$CollisionShape2D.set_deferred("disabled", value)
