extends Node2D

class_name Pawn

signal pawn_destroyed

export(NodePath) var target

onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite
onready var tween = $Tween

const MOVE_DIST = 16
const MOVE_TIME = 1

func _ready() -> void:
	sprite.modulate = Color(1, 1, 1, 1)
	if target:
		if target is NodePath:
			target = get_node(target)
#		target = weakref(target)
		var connections = target.get_signal_connection_list("pawn_destroyed")
		for c in connections:
			if self == c.target:
				return
		target.connect("pawn_destroyed", self, "_on_target_destroyed")

func move() -> void:
	if tween.is_active():
		print("tween active")
		yield()
		return
	if not target:
		print("no target")
		yield()
		return
	if not is_instance_valid(target):
		print("target freed")
		yield()
		return
	var move_pos = (target.global_position - global_position).normalized()
	if abs(move_pos.x) > abs(move_pos.y):
		move_pos.x = sign(move_pos.x)
		move_pos.y = 0
	else:
		move_pos.x = 0
		move_pos.y = sign(move_pos.y)
	move_pos *= MOVE_DIST
	
	print("%s moves by %s" % [name, str(move_pos)])
	
	tween.interpolate_property(self, "position",
		position, position + move_pos, MOVE_TIME,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")

func _on_Area2D_body_entered(body: Node) -> void:
	print("Body %s entered pawn" % body.owner.name)

func _destroy() -> void:
	anim_player.play("destroy")
	yield(anim_player, "animation_finished")
	if tween.is_active():
		yield(tween, "tween_completed")
	emit_signal("pawn_destroyed", self)
	queue_free()

func _on_target_destroyed(t) -> void:
	print("My (%s) target (%s) was destroyed" % [name, t.name])

func _on_Area2D_area_entered(area: Area2D) -> void:
	print("Area %s entered pawn" % area.owner.name)
#	if target == area.owner:
#		target = null
