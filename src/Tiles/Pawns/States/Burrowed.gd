extends TileState

var holes = []

const MAX_HOLES = 4

const HOLE_ID = 0
const DESTROY_OWN_HOLE_CHANCE = 0.2

func enter(previous: State) -> void:
	pawn.burrow()

func update(input: Dictionary) -> void:
	var world = input["world"]
	var pawn_controller = input["pawn_controller"]
	var tile_controller = input["tile_controller"]
	
	if len(holes) == MAX_HOLES:
		if Rng.randf() < DESTROY_OWN_HOLE_CHANCE:
			# Destroy own hole
			var hole = Rng.rand_array_element(holes)
			hole.destroy()
			print("hole destroyed")
			return
	
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
			var hole_offset = Vector2(Rng.randi(-pawn.speed, pawn.speed), Rng.randi(-pawn.speed, pawn.speed))
			hole_pos = pawn.grid_position + hole_offset
			i += 1
			if i > 8:
				print("HEY! %s could not find unoccupied position for hole!" %pawn.name)
				return
		var new_hole = tile_controller.create_tile(HOLE_ID, hole_pos)
		new_hole.connect("tile_destroyed", self, "_on_hole_destroyed")
		holes.append(new_hole)

func _on_hole_destroyed(hole):
	holes.erase(hole)
