extends Node2D

# https://docs.godotengine.org/en/stable/classes/class_physics2ddirectspacestate.html
# https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html

export(int, 0, 500) var line_length := 50
export(int, 0, 100) var start_dist := 0

onready var line = $Line2D

var shadow_prefab = preload("res://src/TestingIdeas/PlayerShadow.tscn")
onready var shadow_parent = $ShadowParent

var shape_params = Physics2DShapeQueryParameters.new()

#const MAX_BOUNCES = 100
#const WALL_SEPARATION = 0 #0.1

#var debug_wall_normal = Vector2()
#var debug_coll_count = 0
#var debug_coll_objects = []
#var debug_duplicate_collision_obj_name = ""

func _ready():
	shape_params.collision_layer = 0b10
#	DebugOverlay.add_stat("Wall normal", self, "debug_wall_normal", false)
#	DebugOverlay.add_stat("Coll count", self, "debug_coll_count", false)
#	DebugOverlay.add_stat("Duplicate collision with object", self, "debug_duplicate_collision_obj_name", false)
	

func set_shape(s) -> void: 
	shape_params.exclude = [owner.get_rid()]
	shape_params.set_shape(s)


func set_direction(dir: Vector2) -> void:
	dir = dir.normalized()
	if dir.length() != 1:
		push_error("Wrong direction for trajectory line: %s" %dir)
		return
	var start_global_position = global_position + dir * start_dist
	shape_params.transform.origin = start_global_position
	shape_params.motion = dir * line_length
	var points_info = PhysicsPrediction.get_shape_trajectory(shape_params)
	
	var points = PoolVector2Array()
	points.append(start_global_position - global_position)
	for point_info in points_info:
		points.append(point_info["global_position"] - global_position)
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

#func set_direction(dir: Vector2) -> void:
#	reset_debug_objects()
#
#	var bounce_count = 0
#	dir = dir.normalized()
#	if dir == Vector2.ZERO:
#		return
#	var space_state = get_world_2d().direct_space_state
#	var remaining_length = line_length
#	var points = PoolVector2Array()
#	var start_position = dir * start_dist
#	var previous_point_global = start_position + global_position
#	points.append(start_position)
#	var DEBUG_WALL_NORMAL_UPDATED = false
#	while remaining_length > 0.0 and bounce_count < MAX_BOUNCES:
#		shape_params.motion = dir * remaining_length
#		shape_params.transform = Transform2D(Vector2.RIGHT, Vector2.DOWN, previous_point_global)
#		var result = space_state.cast_motion(shape_params)
#		if result and result[0] < 1.0 and result[0] > 0.0:
#			var coll_dist = remaining_length * result[0]
#			var coll_vector = dir * coll_dist
#			var next_point_global = previous_point_global + coll_vector
#			# get collision info from collision point
#			shape_params.transform = Transform2D(Vector2.RIGHT, Vector2.DOWN, 
#					previous_point_global + coll_vector)
#			var wall_collision = space_state.get_rest_info(shape_params)
#			if not wall_collision:
#				push_error("Wall collision not detected")
#				return
#				pass
#
#			##
#			##
#			var intersect_data = space_state.intersect_shape(shape_params)
#			var debug_obj_array = []
#			for d in intersect_data:
#				debug_obj_array.append(d.collider)
#			update_debug_objects(debug_obj_array)
#			##
#			##
#
#			#### try sending ray from safe position to objects normal to get wall normal
#			var RADIUS = 10.0
#
#			var raycast = space_state.intersect_ray(next_point_global, next_point_global + wall_collision.normal * RADIUS, [owner.get_rid()], 0b10)
#
#
#			var bounce_normal = (-1 * wall_collision.normal).normalized()
#
#
#			####
#
#			if not DEBUG_WALL_NORMAL_UPDATED:
#				debug_wall_normal = bounce_normal
#				DEBUG_WALL_NORMAL_UPDATED = true
#			next_point_global += bounce_normal * WALL_SEPARATION
#			points.append(next_point_global - global_position)
#			dir = dir.bounce(bounce_normal)
#			dir = dir.normalized()
#			previous_point_global = next_point_global
#			remaining_length -= coll_dist
#			bounce_count += 1
#			# some debugging
#			if dir.length_squared() < Math.EPSILON:
#				push_error("Dir vector is zero!: %s" % dir)
#		else:
#			points.append(previous_point_global + dir * remaining_length - global_position)
#			remaining_length = 0.0
#			break
#	update_shadows(points)
#	update_point_count(points)
#	line.points = points

#func reset_debug_objects():
#	debug_duplicate_collision_obj_name = ""
#	debug_coll_count = 0
#	for o in debug_coll_objects:
#		o.modulate = Color.white
#	debug_coll_objects = []
#
#func update_debug_objects(obj_array):
#	for i in range(len(obj_array)):
#		for j in range(len(obj_array)):
#			if i == j:
#				continue
#			if obj_array[i] == obj_array[j]:
#				debug_duplicate_collision_obj_name = obj_array[i].name
#
#	var colors = [Color.red, Color.green, Color.blue]
#	debug_coll_count = len(obj_array)
#	debug_coll_objects += obj_array
#	for i in range(len(debug_coll_objects)):
#		var obj = debug_coll_objects[i]
#		obj.modulate = colors[i % len(colors)]

#func update_point_count(points):
#	$PointCount.text = str(points.size())
