extends Node2D

# https://docs.godotengine.org/en/stable/classes/class_physics2ddirectspacestate.html
# https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html


func get_shape_trajectory(shape_params: Physics2DShapeQueryParameters, D_CHECK_MOTION = false) -> Array:
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
		if motion_result[0] < Math.EPSILON: # D_CHECK_MOTION and motion_result[0] < Math.EPSILON:
			push_error("Motion distance is 0! [%s, %s]" % motion_result)
			return []
		var dir = shape_params.motion.normalized()
		var total_dist = shape_params.motion.length() 
		var coll_dist = total_dist * motion_result[0]
		var remaining_dist = total_dist - coll_dist
		var coll_center_global_position = shape_params.transform.origin + dir * coll_dist
		
#		shape_params.transform.origin = coll_center_global_position
#		var collision_points = space_state.collide_shape(shape_params)
#		if not collision_points:
#			push_error("Error! 0 collision points")
#			return []
#		var collision_position = Vector2()
#		var collision_normal = Vector2()
#		for c_point in collision_points:
#			collision_normal += coll_center_global_position - c_point
#			collision_position += coll_center_global_position + c_point
#		collision_normal = collision_normal.normalized()
#		collision_position /= len(collision_points)
		
		shape_params.transform.origin = coll_center_global_position
		var rest_info = space_state.get_rest_info(shape_params)
		if not rest_info:
			push_error("Shape did not collide, but should")
			return []
		var collision_point_global_position = rest_info["point"]
		var ray_end_point = rest_info["point"] - rest_info["normal"]
		# Ray is only returning cardinal directions, 
		# even though when colliding with sharp edge real normal is not
		var ray = space_state.intersect_ray(coll_center_global_position, 
				ray_end_point, shape_params.exclude, shape_params.collision_layer)
		if not ray:
			push_error("Ray did not collide, but should")
			return []
		var collision_normal = ray["normal"].normalized()
		
		
#		if motion_result[0] < Math.EPSILON:
#			# We are aiming straight at wall while colliding with it
#			shape_params.motion = shape_params.motion.reflect(collision_normal)
#			# Move slightly away from wall
#			shape_params.transform.origin += collision_normal * 0.2
#			return get_shape_trajectory(shape_params, true)


		var new_dir = dir.bounce(collision_normal)
		shape_params.motion = new_dir * remaining_dist
		var point = {
			"global_position": coll_center_global_position, 
			"collided": true,
			"collision_global_position": collision_point_global_position,
			"normal": collision_normal
		}
		return [point] + get_shape_trajectory(shape_params)
	else:
		# No collision
		return [{
			"global_position": shape_params.transform.origin + shape_params.motion,
			"collided": false,
#			"collision_global_position": Vector2.ZERO,
#			"normal": Vector2.ZERO
		}]
