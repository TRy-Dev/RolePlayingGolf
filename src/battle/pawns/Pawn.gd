extends Node2D

class_name Pawn

signal pawn_destroyed

var target
export(String) var destroy_sound
export(String) var color

onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite
onready var tween = $Tween
onready var collision = $Area2D/CollisionShape2D
onready var battle = owner

export(int) var move_dist = 0
const MOVE_SPEED = 40

var is_destroyed = false

func _ready() -> void:
	sprite.modulate = Colors.get_color(color)
	collision.disabled = false
	if target:
		if target is NodePath:
			target = get_node(target)
#		target = weakref(target)
#		var connections = target.get_signal_connection_list("pawn_destroyed")
#		for c in connections:
#			if self == c.target:
#				return
#		target.connect("pawn_destroyed", self, "_on_target_destroyed")

func move():
	assert(target != null, "Target is null")
	if tween.is_active():
		print("--- tween active. possible bug")
		yield(get_tree(), "idle_frame")
		return
	if not target:
		print("--- no target to move to. possible bug")
		yield(get_tree(), "idle_frame")
		return
	if not is_instance_valid(target):
		print("--- target instance not valid. possible bug")
		yield(get_tree(), "idle_frame")
		return
	
	var move_dist_left = move_dist
	while move_dist_left > 0:
		var move_dist = min(move_dist_left, 0.5 * GameData.TILE_SIZE)
		move_dist_left -= 0.5 * GameData.TILE_SIZE
		_find_target_if_null()
		if target == null:
			yield(get_tree(), "idle_frame")
			return
#		var target_dir = (target.global_position - global_position).normalized()
#		var move_pos = _get_valid_dir(target_dir)
		
		if not battle:
			battle = owner
			if not battle:
				print("Could not find 'battle' as owner for navigation for pawn %s" % name)
				yield(get_tree(), "idle_frame")
				return
		var dir = battle.get_nav_dir(global_position, target.global_position)
		
#		_debug_raycast_collisions()
		tween.interpolate_property(self, "position",
		global_position, global_position + dir * move_dist, float(move_dist) / MOVE_SPEED,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		SoundEffects.play_audio("step")
		tween.start()
		yield(tween, "tween_completed")

func _on_Area2D_body_entered(body: Node) -> void:
	print("Body %s entered pawn" % body.owner.name)

func _destroy() -> void:
	is_destroyed = true
	collision.set_deferred("disabled", true)
	anim_player.play("destroy")
	SoundEffects.play_audio(destroy_sound)
	yield(anim_player, "animation_finished")
	if tween.is_active():
		yield(tween, "tween_completed")
	queue_free()
	emit_signal("pawn_destroyed", self)

func find_target() -> bool:
	return false

func _on_target_destroyed(t) -> void:
	print("My (%s) target (%s) was destroyed" % [name, t.name])

func _on_Area2D_area_entered(area: Area2D) -> void:
	print("Area %s entered %s" % [area.owner.name, name])
#	if target == area.owner:
#		target = null

onready var _raycasts = {
	Vector2( 1, 0): [
		$Area2D/RayRight,
		$Area2D/RayRight2
	],
	Vector2(-1, 0): [
		$Area2D/RayLeft,
		$Area2D/RayLeft2,
	],
	Vector2( 0, 1): [
		$Area2D/RayDown,
		$Area2D/RayDown2,
	],
	Vector2( 0,-1): [
		$Area2D/RayUp,
		$Area2D/RayUp2,
	]
}
#onready var _raycasts = {
#	[ 1, 0]: $Raycasts/Right,
#	[-1, 0]: $Raycasts/Left,
#	[ 0, 1]: $Raycasts/Down,
#	[ 0,-1]: $Raycasts/Up,
#}
func _are_rays_coliding(dir: Vector2) -> bool:
	if not dir in _raycasts:
		print("No such raycast direction: %s" % dir)
		print("NO COLLISIONS")
		return false
	for ray in _raycasts[dir]:
		if ray.is_colliding():
			return true
	return false

func _get_valid_dir(dir: Vector2) -> Vector2:
	if dir.x == 0 and dir.y == 0:
		return dir
	# if path blocked walk left
	dir = get_dir(dir)
	var start_dir = Vector2(dir.x, dir.y)
	if _are_rays_coliding(dir):	
		dir = start_dir.rotated(-PI / 2)
		dir = Vector2(round(dir.x), round(dir.y))
	else:
		return dir
	# if left blocked walk right
	if _are_rays_coliding(dir):
		dir = start_dir.rotated(PI / 2)
		dir = Vector2(round(dir.x), round(dir.y))
	else:
		return dir
	# if right blocked walk back
	if _are_rays_coliding(dir):
		dir = start_dir.rotated(PI)
		dir = Vector2(round(dir.x), round(dir.y))
	else:
		return dir
	# if back is blocked stay
	if _are_rays_coliding(dir):
		return Vector2()
	else:
		return dir
	

func get_dir(vec :Vector2) -> Vector2:
	var dir = Vector2()
	if abs(vec.x) > abs(vec.y):
		dir.x = sign(vec.x)
		dir.y = 0
	else:
		dir.x = 0
		dir.y = sign(vec.y)
	return dir

func _find_target_if_null():
	print("Finding target for %s" % name)
	pass

func _debug_raycast_collisions():
	var dir = Vector2(1, 0)
	# if path blocked walk left
	dir = get_dir(dir)
	var collisions = {
		"right": _are_rays_coliding(Vector2(1, 0)),
		"left": _are_rays_coliding(Vector2(-1, 0)),
		"down": _are_rays_coliding(Vector2(0, 1)),
		"up": _are_rays_coliding(Vector2(0, -1)),
	}
	print("--- COLLISIONS %s ---" % name)
	print(collisions)
	return collisions

func highlight():
	anim_player.play("highlight")
