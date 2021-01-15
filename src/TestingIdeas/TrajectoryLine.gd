extends Node2D

export(int, 0, 500) var line_length := 50
export(int, 0, 100) var start_dist := 0

onready var line = $Line2D

var shadow_prefab = preload("res://src/TestingIdeas/PlayerShadow.tscn")
var marker_prefab = preload("res://src/TestingIdeas/Marker.tscn")
onready var shadow_parent = $ShadowParent
onready var marker_parent = $CollMarkerParent

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
	refresh_coll_markers(points_info)
	line.points = points
	
func refresh_shadows(points: PoolVector2Array) -> void:
	for c in shadow_parent.get_children():
		c.free()
	for i in range(1, points.size() -1):
		_add_shadow(points[i])

func refresh_coll_markers(points_info: Array) -> void:
	for m in marker_parent.get_children():
		m.free()
	for i in range(len(points_info)):
		var p_i = points_info[i]
		if p_i.collided:
			_add_marker(p_i.collision_global_position, p_i.normal, str(i))

func _add_marker(global_pos: Vector2, normal: Vector2, text: String) -> void:
	var marker = marker_prefab.instance()
	marker_parent.add_child(marker)
	marker.global_position = global_pos
	marker.set_direction(normal)
	marker.set_text(text)


func _add_shadow(pos: Vector2) -> void:
	var shadow = shadow_prefab.instance()
	shadow_parent.add_child(shadow)
	shadow.position = pos
