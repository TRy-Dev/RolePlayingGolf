extends KinematicBody2D

onready var cursor = $Cursor

var acceleration :Vector2
var velocity :Vector2
var drag = 0.3
var mass :float
var friction_coeff = 0.5
var bounce_decay = 0.5

var direction :Vector2 = Vector2(1, 0)
const DIR_CHANGE_SPEED = 3
const MIN_STRENGTH = 100
const MAX_STRENGTH = 200
var current_strength = (MIN_STRENGTH + MAX_STRENGTH) / 2
const STR_CHANGE_SPEED = 200

func _ready() -> void:
	mass = 1
	_rotate(0)
	_change_strength(0)

func apply_force(force) -> void:
	acceleration += force / mass;

func handle_input() -> void:
	var x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y = Input.get_action_strength("up") - Input.get_action_strength("down")
	if x:
		_rotate(x)
	if y:
		_change_strength(y)
	if Input.is_action_just_pressed("action"):
		apply_force(direction * current_strength)

func _rotate(dir) -> void:
	direction = direction.rotated(dir * DIR_CHANGE_SPEED * get_physics_process_delta_time())
	cursor.rotate(direction.angle() + PI / 4)
	
func _change_strength(amount) -> void:
	current_strength += amount * STR_CHANGE_SPEED * get_physics_process_delta_time()
	current_strength = max(current_strength, MIN_STRENGTH)
	current_strength = min(current_strength, MAX_STRENGTH)
	cursor.set_strength_percent((current_strength - MIN_STRENGTH) / (MAX_STRENGTH - MIN_STRENGTH))

func _physics_process(delta: float) -> void:
	handle_input()
	# apply forces
	var friction = Vector2(velocity.x, velocity.y)
	friction *= -1
	friction = friction.normalized()
	friction *= friction_coeff
	apply_force(friction)
	
	# move
	velocity += acceleration;
	move_and_slide(velocity)
	acceleration = Vector2()
	
	# collide
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		velocity = velocity.bounce(collision.normal)
		acceleration = acceleration.bounce(collision.normal)
		acceleration *= (1.0 - bounce_decay)
