extends PawnState

var anchor_position = null

func initialize() -> void:
	.initialize()
	anchor_position = pawn.grid_position

func update(input: Dictionary) -> void:
	# Input: world, pawn_controller, pawn
#	var pawn = input["pawn"]
	var world = input["world"]
	var pawn_controller = input["pawn_controller"]
	
	var distance_to_target = (pawn.grid_position - anchor_position).length()
	var start_pos = pawn.grid_position
	var target_pos = start_pos
	if distance_to_target > pawn.speed:
		# Pawn is far, should move towards target
		target_pos = anchor_position
	else:
		# Pawn is close, should move randomly
		var delta = Vector2.ZERO
		for i in range(pawn.speed):
			delta += Rng.rand_array_element(Math.CARDINAL_DIRECTIONS)
		target_pos = start_pos + delta
	var path = world.get_nav_path(start_pos, target_pos)
	if len(path) > 1:
		var end_pos = path[min(pawn.speed, len(path) - 1)]
		pawn_controller.move_pawn(start_pos, end_pos)
