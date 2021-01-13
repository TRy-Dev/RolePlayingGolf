extends Node2D


func get_shape_trajectory(shape_params: Physics2DShapeQueryParameters) -> Array:
	var space_state = get_world_2d().direct_space_state
	if shape_params.motion == Vector2():
		push_error("Motion is zero!")
		return []
	var motion_result = space_state.cast_motion(shape_params)
	if not motion_result:
		push_error("Shape can't move!")
		return []
	if motion_result[0] < 1:
		# collided on the way
		if motion_result[0] < Math.EPSILON:
			push_error("Motion distance is 0! [%s, %s]" % motion_result)
			return []
		var dir = shape_params.motion.normalized()
		var total_dist = shape_params.motion.length() 
		var coll_dist = total_dist * motion_result[0]
		var remaining_dist = total_dist - coll_dist
		var coll_center_global_position = shape_params.transform.origin + dir * coll_dist
		shape_params.transform.origin = coll_center_global_position
		var rest_info = space_state.get_rest_info(shape_params)
		if not rest_info:
			push_error("Shape did not collide, but should")
			return []
		var ray_end_point = rest_info["point"] - rest_info["normal"]
		var ray = space_state.intersect_ray(coll_center_global_position, 
				ray_end_point, shape_params.exclude, shape_params.collision_layer)
		if not ray:
			push_error("Ray did not collide, but should")
			return []
		var collision_normal = ray["normal"].normalized()
		var new_dir = dir.bounce(collision_normal)
		shape_params.motion = new_dir * remaining_dist
		var point = {
			"global_position": coll_center_global_position,
			"collided": true,
			"collision_global_position": rest_info["point"],
			"normal": collision_normal
		}
		return [point] + get_shape_trajectory(shape_params)
	else:
		# No collision
		return [{
			"global_position": shape_params.transform.origin + shape_params.motion,
			"collided": false,
			"collision_global_position": Vector2.ZERO,
			"normal": Vector2.ZERO
		}]
	return []
