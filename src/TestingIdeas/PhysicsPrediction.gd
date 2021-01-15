extends Node2D

# https://docs.godotengine.org/en/stable/classes/class_physics2ddirectspacestate.html
# https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html

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
		if motion_result[0] < Math.EPSILON:
			shape_params =  _bounce_direction_off_wall(shape_params)
			motion_result = space_state.cast_motion(shape_params)
			if not motion_result or motion_result[0] <= Math.EPSILON:
				push_error("Motion distance is 0! [%s, %s]" % motion_result)
				return []
		var motion_direction = shape_params.motion.normalized()
		var motion_distance = shape_params.motion.length()
		var collision_distance = motion_distance * motion_result[0]
		var remaining_distance = motion_distance - collision_distance
		var center_position = shape_params.transform.origin + collision_distance * motion_direction
		
		shape_params.transform.origin = center_position
		shape_params.motion = motion_direction #(motion_result[1] - motion_result[0]) * motion_direction
		
		# To get collision position and normal we have 2 options
		# space_state.get_rest_info - return coll_pos and normal - EASIER
		# space_state.collide_shape - returns list of contact points - if ^ doesn't work
		
		var rest_info = space_state.get_rest_info(shape_params)
		if not rest_info:
			push_error("Shape did not collide, but should")
			return []
		var collision_position = rest_info.point
		var normal = rest_info.normal
		var new_motion_direction = motion_direction.bounce(normal).normalized()
		
		shape_params.motion = new_motion_direction * remaining_distance
		return [{
			"position": center_position,
			"collided": true,
			"collision_position": collision_position,
			"normal": normal
		}] + get_shape_trajectory(shape_params)
	else:
		return [{
				"position": shape_params.transform.origin + shape_params.motion,
				"collided": false,
			}]


func _bounce_direction_off_wall(shape_params: Physics2DShapeQueryParameters) -> Physics2DShapeQueryParameters:
	var space_state = get_world_2d().direct_space_state
	var rest_info = space_state.get_rest_info(shape_params)
	if not rest_info:
		push_error("should have collided")
		return shape_params
	var new_motion = shape_params.motion.reflect(rest_info.normal)
	shape_params.motion = new_motion
	return shape_params
