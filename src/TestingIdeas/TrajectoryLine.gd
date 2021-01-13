extends Node2D

export(int, 0, 500) var line_length := 50
export(int, 0, 100) var start_dist := 0

onready var line = $Line2D

var shadow_prefab = preload("res://src/TestingIdeas/PlayerShadow.tscn")
onready var shadow_parent = $ShadowParent

var shape_params = Physics2DShapeQueryParameters.new()

func _ready():
	shape_params.collision_layer = 0b10

func set_shape(s) -> void: 
	shape_params.exclude = [owner.get_rid()]
	shape_params.set_shape(s)


func set_direction(dir: Vector2) -> void:
	dir = dir.normalized()
	if dir.length() != 1:
		push_error("Wrong direction for trajectory line: %s" %dir)
		return
	shape_params.transform.origin = global_position
	shape_params.motion = dir * line_length
	var points_info = PhysicsPrediction.get_shape_trajectory(shape_params)
	
	var points = PoolVector2Array()
	points.append(dir * start_dist)
	for pi in points_info:
		points.append(pi["global_position"] - global_position)
	refresh_shadows(points)
	line.points = points
	
func refresh_shadows(points: PoolVector2Array) -> void:
	for c in shadow_parent.get_children():
		c.free()
	for i in range(1, points.size() -1):
		_add_shadow(points[i])

func _add_shadow(pos: Vector2) -> void:
	var shadow = shadow_prefab.instance()
	shadow_parent.add_child(shadow)
	shadow.position = pos
