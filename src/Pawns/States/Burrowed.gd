extends PawnState

var holes = []

const MAX_HOLES = 4

const HOLE_ID = 0

func enter(previous: State) -> void:
	pawn.burrow()

func update(input: Dictionary) -> void:
	var world = input["world"]
	var pawn_controller = input["pawn_controller"]
	var dynamic_environment = input["dynamic_environment"]
	
	var unburrow_chance = float(len(holes)) / MAX_HOLES
	if Rng.randf() < unburrow_chance:
		var hole = Rng.rand_array_element(holes)
		pawn_controller.move_pawn(pawn.grid_position, hole.grid_position)
		yield(get_tree().create_timer(GlobalConstants.MOVE_TIME), "timeout")
		emit_signal("finished", "Unburrowed")
	else:
		var hole_pos = pawn.grid_position #+ Vector2(Rng.randi(0, pawn.speed), Rng.randi(0, pawn.speed))
		var i = 0
		while not world.is_position_unoccupied(hole_pos):
			var hole_offset = Vector2(Rng.randi(0, pawn.speed), Rng.randi(0, pawn.speed))
			hole_pos = pawn.grid_position + hole_offset
			i += 1
			if i > 8:
				print("HEY! Rat could not find unoccupied position for hole!")
				return
		var new_hole = dynamic_environment.create_dynamic_tile(HOLE_ID, hole_pos)
		new_hole.connect("destroyed", self, "_on_hole_destroyed")
		holes.append(new_hole)

func _on_hole_destroyed(hole):
	holes.erase(hole)
