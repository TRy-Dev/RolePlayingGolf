extends Tile

class_name Pawn

func move_to(grid_pos: Vector2) -> void:
	grid_position = grid_pos
	var target_position =  GlobalConstants.grid_to_world(grid_pos)
	$Tween.stop_all()
	$Tween.interpolate_property(self, "global_position", 
			global_position, target_position, GlobalConstants.MOVE_TIME, 
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
