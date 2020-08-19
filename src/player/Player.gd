extends KinematicBody2D

onready var cursor = $Cursor
onready var collider = $CollisionShape2D

var acceleration :Vector2
var velocity :Vector2
var mass :float
var friction_coeff = 0.02
var bounce_decay = 0.3

var direction :Vector2 = Vector2(0, -1)
const DIR_CHANGE_SPEED = 3
const MIN_STRENGTH = 50
const MAX_STRENGTH = 300
var current_strength = (MIN_STRENGTH + MAX_STRENGTH) / 2
const STR_CHANGE_SPEED = 200

const MIN_MOVE_VELOCITY = 15
var is_moving :bool = false

var rot_amount = 0.0

func _ready() -> void:
	mass = 1
	_rotate(0)
	_change_strength(0)
	cursor.hide()

func apply_force(force) -> void:
	acceleration += force / mass;

func handle_input() -> void:
	if is_moving:
		cursor.hide()
		return
	else:
		cursor.show()
	var x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y = Input.get_action_strength("up") - Input.get_action_strength("down")
	if x:
		_rotate(x)
	else:
		rot_amount = 0.0
	if y:
		_change_strength(y)
	if Input.is_action_just_pressed("action"):
		SoundEffects.play_audio("hit")
		apply_force(direction * current_strength)

func _rotate(dir) -> void:
	rot_amount = lerp(rot_amount, dir * DIR_CHANGE_SPEED * get_physics_process_delta_time(), 0.1)
	direction = direction.rotated(rot_amount)
	cursor.rotate(direction.angle() + PI / 4)
	
func _change_strength(amount) -> void:
	current_strength += amount * STR_CHANGE_SPEED * get_physics_process_delta_time()
	current_strength = max(current_strength, MIN_STRENGTH)
	current_strength = min(current_strength, MAX_STRENGTH)
	cursor.set_strength_percent((current_strength - MIN_STRENGTH) / (MAX_STRENGTH - MIN_STRENGTH))

func _physics_process(delta: float) -> void:
	# apply forces
	var friction = Vector2(velocity.x, velocity.y)
	friction *= -1
#	if Input.is_action_pressed("action"):
#		friction *= 3 * friction_coeff
#	else:
#		friction *= friction_coeff
	friction *= friction_coeff
	apply_force(friction)
	
	# move
	velocity += acceleration;
	
	if velocity.length() < MIN_MOVE_VELOCITY and is_moving:
		velocity = Vector2()
		is_moving = false
	elif velocity.length() >= MIN_MOVE_VELOCITY and not is_moving:
		is_moving = true
	
	move_and_slide(velocity)
	acceleration = Vector2()
	
	# collide
	for i in get_slide_count():
		SoundEffects.play_audio("hit")
		var collision = get_slide_collision(i)
		velocity = velocity.bounce(collision.normal)
		acceleration = acceleration.bounce(collision.normal)
		global_position += collision.normal
		acceleration *= (1.0 - bounce_decay)
		break

func set_disable_collision(value) -> void:
	collider.disabled = value
