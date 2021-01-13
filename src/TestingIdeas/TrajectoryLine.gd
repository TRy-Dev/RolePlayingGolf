extends Node2D

# https://docs.godotengine.org/en/stable/classes/class_physics2ddirectspacestate.html
# https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html

export(int, 0, 500) var line_length := 24
export(int, 0, 100) var start_dist := 0

onready var line = $Line2D

var shadow_prefab = preload("res://src/TestingIdeas/PlayerShadow.tscn")
onready var shadow_parent = $ShadowParent

var shape_params = Physics2DShapeQueryParameters.new()

const MAX_BOUNCES = 100
const WALL_SEPARATION = 0.1

var debug_wall_normal = Vector2()

func _ready():
	DebugOverlay.add_stat("Wall normal", self, "debug_wall_normal", false)

func set_shape(s) -> void: 
	shape_params.collision_layer = 0b10
	shape_params.exclude = [owner.get_rid()]
	shape_params.set_shape(s)

func _get_shape_trajectory(shape: Physics2DShapeQueryParameters, dir: Vector2, distance: float) -> Array:
	var some_point = {
		"global_position": Vector2(),
		"collided": false,
		"collision_global_position": Vector2(),
		"normal": Vector2()
	}
	return []

func set_direction(dir: Vector2) -> void:
	var bounce_count = 0
	dir = dir.normalized()
	if dir == Vector2.ZERO:
		return
	var space_state = get_world_2d().direct_space_state
	var remaining_length = line_length
	var points = PoolVector2Array()
	var start_position = dir * start_dist
	var previous_point_global = start_position + global_position
	points.append(start_position)
	var DEBUG_WALL_NORMAL_UPDATED = false
	while remaining_length > 0.0 and bounce_count < MAX_BOUNCES:
		shape_params.motion = dir * remaining_length
		shape_params.transform = Transform2D(Vector2.RIGHT, Vector2.DOWN, previous_point_global)
		var result = space_state.cast_motion(shape_params)
		if result and result[0] < 1.0 and result[0] > 0.0:
			var coll_dist = remaining_length * result[0]
			var coll_vector = dir * coll_dist
			var next_point_global = previous_point_global + coll_vector
			# get collision info from collision point
			shape_params.transform = Transform2D(Vector2.RIGHT, Vector2.DOWN, 
					previous_point_global + coll_vector)
			var wall_collision = space_state.get_rest_info(shape_params)
			if not wall_collision:
				push_error("Wall collision not detected")
				return
				pass
			var bounce_normal = (-1 * wall_collision.normal).normalized()
			if not DEBUG_WALL_NORMAL_UPDATED:
				debug_wall_normal = bounce_normal
				DEBUG_WALL_NORMAL_UPDATED = true
			next_point_global += bounce_normal * WALL_SEPARATION
			points.append(next_point_global - global_position)
			dir = dir.bounce(bounce_normal)
			dir = dir.normalized()
			previous_point_global = next_point_global
			remaining_length -= coll_dist
			bounce_count += 1
			# some debugging
			if dir.length_squared() < Math.EPSILON:
				push_error("Dir vector is zero!: %s" % dir)
		else:
			points.append(previous_point_global + dir * remaining_length - global_position)
			remaining_length = 0.0
			break
#	points = remove_duplicate_points(points)
	update_shadows(points)
	update_point_count(points)
	line.points = points

func remove_duplicate_points(points) -> PoolVector2Array:
	var COMBINE_DIST_SQ = pow(2, 2)
	var out = PoolVector2Array()
	for i in range(len(points)):
		if i > 0:
			if (out[out.size()-1] - points[i]).length_squared() > COMBINE_DIST_SQ:
				out.append(points[i])
		else:
			out.append(points[i])
	if (out[out.size() - 1] - points[points.size() - 1]).length_squared() > COMBINE_DIST_SQ:
		out.append(points[points.size() - 1])
	return out

func update_shadows(points: PoolVector2Array) -> void:
	for c in shadow_parent.get_children():
		c.free()
	for i in range(1, points.size() -1):
		_add_shadow(points[i])

func _add_shadow(pos: Vector2) -> void:
	var shadow = shadow_prefab.instance()
	shadow_parent.add_child(shadow)
	shadow.position = pos

func update_point_count(points):
	$PointCount.text = str(points.size())

#func _round_vector_to_cardinal_directions(v: Vector2) -> Vector2:
#	var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
##	if not v in directions:
##		print("Wrong direction! %s" %v)
#	for d in directions:
#		if v.angle_to(d) <= 0.25001 * PI and v.angle_to(d) >= -0.25001 * PI:
#			return d
#	return Vector2.ZERO

#func set_direction(dir: Vector2) -> void:
#	dir = dir.normalized()
#	var start_global_pos = global_position + dir * start_dist
#
#	var space_state = get_world_2d().direct_space_state
#	var shape_params = Physics2DShapeQueryParameters.new()
#	shape_params.collision_layer = 0b10
#	shape_params.exclude = [owner]
#	shape_params.motion = dir * line_length
#	shape_params.transform = Transform2D(Vector2(1, 0), Vector2(0, 1), start_global_pos)
#	shape_params.set_shape(shape)
#	var result = space_state.cast_motion(shape_params)
#	var points = PoolVector2Array()
#	if result:
#		points.append(start_global_pos - global_position)
#		points.append(dir * line_length * result[0])
##		points.append(dir * line_length * result[1])
#	line.points = points


# PhysicsShapeQueryParameters2D
#Array Physics2DDirectSpaceState::_cast_motion(const Ref<Physics2DShapeQueryParameters> &p_shape_query) {
#
#	ERR_FAIL_COND_V(!p_shape_query.is_valid(), Array());
#
#	float closest_safe, closest_unsafe;
#	bool res = cast_motion(p_shape_query->shape, p_shape_query->transform, p_shape_query->motion, p_shape_query->margin, closest_safe, closest_unsafe, p_shape_query->exclude, p_shape_query->collision_mask, p_shape_query->collide_with_bodies, p_shape_query->collide_with_areas);
#	if (!res)
#		return Array();
#	Array ret;
#	ret.resize(2);
#	ret[0] = closest_safe;
#	ret[1] = closest_unsafe;
#	return ret;
#}



#func set_direction(dir: Vector2) -> void:
#	dir = dir.normalized()
#	var dir_angle_rad = dir.angle()
#	var remaining_length = line_length
#	var start_pos = dir * start_dist
#	var previous_point = start_pos
#	var points = PoolVector2Array()
#	while remaining_length > 0.0:
#		var center_global_pos = previous_point + global_position
#		var center_coll = _get_ray_collision(center_global_pos, dir, remaining_length)
#		var left_edge_global = center_global_pos + dir.rotated(-0.5 * PI) * BODY_RADIUS
#		var right_edge_global = center_global_pos + dir.rotated(0.5 * PI) * BODY_RADIUS
#		var left_coll = _get_ray_collision(left_edge_global, dir, remaining_length)
#		var right_coll = _get_ray_collision(right_edge_global, dir, remaining_length)
#		var closest_coll = _get_closest_collision(
#			[center_coll, left_coll, right_coll],
#			[0.0, BODY_RADIUS - cos(dir_angle_rad), BODY_RADIUS + cos(dir_angle_rad)])
#		if closest_coll:
#			if points.size() < 1:
#				previous_point = closest_coll["from_global_position"] - global_position
#				points.append(previous_point)
#			var previous_to_collision = closest_coll["global_position"] - previous_point - global_position
#			# Move slightly away from wall to avoid colliding with it infinitely
#			previous_to_collision += closest_coll["normal"] * POINT_WALL_DISTANCE
#			var current_point = previous_point + previous_to_collision + closest_coll["normal"] * BODY_RADIUS
#			dir = previous_to_collision.bounce(closest_coll["normal"]).normalized()
#			remaining_length -= previous_to_collision.length()
#			points.append(current_point)
#			previous_point = current_point
#		else:
#			if points.size() < 1:
#				points.append(start_pos)
#			points.append(previous_point + dir * remaining_length)
#			remaining_length = 0.0
#			break
#	line.points = points
#
#func _get_closest_collision(colls :Array, penalties :Array):
#	var closest_idx = -1
#	var closest
#	for i in range(len(colls)):
#		var c = colls[i]
#		if not c:
#			continue
#		if closest_idx < 0:
#			closest_idx = i
#			closest = c
#			continue
#		if c["distance"] + penalties[i] < closest["distance"] + penalties[closest_idx]:
#			closest_idx = i
#			closest = c
#			continue
#	return closest

#func set_direction(dir: Vector2) -> void:
#	dir = dir.normalized()
#	var remaining_length = line_length
#	var start_pos = dir * start_dist
#	var previous_point = start_pos
#	var points = PoolVector2Array()
#	points.append(start_pos)
#	while remaining_length > 0.0:
#		var coll = _get_ray_collision(previous_point + global_position, dir, remaining_length)
#		if coll:
#			var previous_to_collision = coll["global_position"] - previous_point - global_position
#			# Move slightly away from wall to avoid colliding with it infinitely
#			previous_to_collision += coll["normal"] * POINT_WALL_DISTANCE
#			var current_point = previous_point + previous_to_collision
#			dir = previous_to_collision.bounce(coll["normal"]).normalized()
#			remaining_length -= previous_to_collision.length()
#			points.append(current_point)
#			previous_point = current_point
#		else:
#			points.append(previous_point + dir * remaining_length)
#			remaining_length = 0.0
#			break
#	line.points = points

#func _get_ray_collision(from_global_pos: Vector2, dir: Vector2, distance: float):
#	ray.global_position = from_global_pos
#	ray.cast_to = dir * distance
#	ray.enabled = true
#	ray.force_raycast_update()
#	if not ray.is_colliding():
#		return null
#	var collider = {
#		"from_global_position": from_global_pos,
#		"global_position": ray.get_collision_point(),
#		"distance": (ray.get_collision_point() - from_global_pos).length(),
#		"normal": ray.get_collision_normal(),
#		"collider": ray.get_collider()
#	}
#	ray.enabled = false
#	return collider
