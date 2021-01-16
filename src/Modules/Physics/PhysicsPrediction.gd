extends Node2D

# https://docs.godotengine.org/en/stable/classes/class_physics2ddirectspacestate.html
# https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# https://docs.godotengine.org/en/stable/classes/class_physics2dshapequeryparameters.html

# This module is WIP
# Expect to encounter bugs and inaccuracies in prediction (mostly on sharp corners)
# Some errors are commented out, as they do not matter for this project (Role Playing Golf)
# With that said, current funcionalities are sufficient for Role Playing Golf

# Input shape_params
#		You should set up:
#				* start global position (through transform)
#				* motion (with direction and total distance
#				* shape, collison layers and exclusions
#				* ! not sure about margin. Was tested with margin=0.0. 
#						Setting it to KinematicBody2D margin seemed to not improve accuracy, but resulted in errors (not motion_result)
# Function will check for any collisions on the way and if detected, will bounce off and recursively continue until total distance (shape_params.motion.length) is traversed
# Output list of points with data about safe (non-colliding) position,
# 		collision normal and collision position
func get_shape_trajectory(shape_params: Physics2DShapeQueryParameters) -> Array:
	var space_state = get_world_2d().direct_space_state
	
	if shape_params.motion == Vector2():
		push_error("Motion is zero!")
		return []
	
	var motion_result = space_state.cast_motion(shape_params)
	if not motion_result:
		push_error("Shape can't move!")
		return []
	
	if motion_result[0] < Math.EPSILON:
		shape_params =  _bounce_direction_off_wall(shape_params)
		motion_result = space_state.cast_motion(shape_params)
	
	if motion_result[0] < 1 and motion_result[0] > 0:
		var motion_direction = shape_params.motion.normalized()
		var motion_distance = shape_params.motion.length()
		var safe_distance = motion_distance * motion_result[0]
		var unsafe_distance = motion_distance * motion_result[1]
		var remaining_distance = motion_distance - safe_distance
		var safe_position = shape_params.transform.origin + safe_distance * motion_direction
		var unsafe_position = shape_params.transform.origin + unsafe_distance * motion_direction
		
		shape_params.transform.origin = unsafe_position
		# Without motion prediction is more accurate
		shape_params.motion = Vector2.ZERO # motion_direction
		var rest_info = space_state.get_rest_info(shape_params)
		if not rest_info:
#			push_error("Shape did not collide, but should")
			return []
		if rest_info.linear_velocity != Vector2.ZERO:
			print("HEY! Linear velocity is not zero, but should be for KinematicBody2D!")
		var collision_position = rest_info.point
		var normal = rest_info.normal
		var new_motion_direction = motion_direction.bounce(normal).normalized()
		
		shape_params.transform.origin = safe_position
		shape_params.motion = new_motion_direction * remaining_distance
		return [{
			"position": safe_position,
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
	var start_motion = shape_params.motion
	var space_state = get_world_2d().direct_space_state
	shape_params.motion = shape_params.motion.normalized() # Move only slightly forward
	var rest_info = space_state.get_rest_info(shape_params)
	if not rest_info:
#		push_error("should have collided")
		return shape_params
	if rest_info.linear_velocity != Vector2.ZERO:
		print("HEY! Linear velocity is not zero, but should be for KinematicBody2D!")
	var new_motion = start_motion.bounce(rest_info.normal)
	shape_params.motion = new_motion
	return shape_params
