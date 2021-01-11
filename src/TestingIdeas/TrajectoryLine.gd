extends Node2D

export(int, 0, 500) var line_length := 24
export(int, 0, 100) var start_dist := 0

onready var line = $Line2D
onready var ray = $RayCast2D

const POINT_WALL_DISTANCE := 0.04
const BODY_RADIUS := 6.0

func set_direction(dir: Vector2) -> void:
	dir = dir.normalized()
	var dir_angle_rad = dir.angle()
	var remaining_length = line_length
	var start_pos = dir * start_dist
	var previous_point = start_pos
	var points = PoolVector2Array()
#	points.append(start_pos)
	while remaining_length > 0.0:
		var center_global_pos = previous_point + global_position
		var center_coll = _get_ray_collision(center_global_pos, dir, remaining_length)
		var left_edge_global = center_global_pos + dir.rotated(-0.5 * PI) * BODY_RADIUS
		var right_edge_global = center_global_pos + dir.rotated(0.5 * PI) * BODY_RADIUS
		var left_coll = _get_ray_collision(left_edge_global, dir, remaining_length)
		var right_coll = _get_ray_collision(right_edge_global, dir, remaining_length)
		var closest_coll = _get_closest_collision(
			[center_coll, left_coll, right_coll],
			[0.0, BODY_RADIUS - cos(dir_angle_rad), BODY_RADIUS + cos(dir_angle_rad)])
		if closest_coll:
			if points.size() < 1:
				previous_point = closest_coll["from_global_position"] - global_position
				points.append(previous_point)
			var previous_to_collision = closest_coll["global_position"] - previous_point - global_position
			# Move slightly away from wall to avoid colliding with it infinitely
			previous_to_collision += closest_coll["normal"] * POINT_WALL_DISTANCE
			var current_point = previous_point + previous_to_collision
			dir = previous_to_collision.bounce(closest_coll["normal"]).normalized()
			remaining_length -= previous_to_collision.length()
			points.append(current_point)
			previous_point = current_point
		else:
			if points.size() < 1:
				points.append(start_pos)
			points.append(previous_point + dir * remaining_length)
			remaining_length = 0.0
			break
	line.points = points

func _get_closest_collision(colls :Array, penalties :Array):
	var closest_idx = -1
	var closest
	for i in range(len(colls)):
		var c = colls[i]
		if not c:
			continue
		if closest_idx < 0:
			closest_idx = i
			closest = c
			continue
		if c["distance"] + penalties[i] < closest["distance"] + penalties[closest_idx]:
			closest_idx = i
			closest = c
			continue
	return closest

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

func _get_ray_collision(from_global_pos, dir, distance):
	ray.global_position = from_global_pos
	ray.cast_to = dir * distance
	ray.enabled = true
	ray.force_raycast_update()
	if not ray.is_colliding():
		return null
	var collider = {
		"from_global_position": from_global_pos,
		"global_position": ray.get_collision_point(),
		"distance": (ray.get_collision_point() - from_global_pos).length(),
		"normal": ray.get_collision_normal(),
		"collider": ray.get_collider()
	}
	ray.enabled = false
	return collider
