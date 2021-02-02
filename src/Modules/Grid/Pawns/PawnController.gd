extends TileMap

signal pawn_created(index, pos)
signal pawn_destroyed(index, pos)
signal pawn_moved(index, pos_from, pos_to)

# Dict Vector2 -> Pawn
var _pawns := {}

func initialize(walkable: TileMap) -> void:
	var pawns_grid_positions = get_used_cells()
	var outside_ground_count = 0
	for pos in pawns_grid_positions:
		var idx = get_pawn_id_at(pos)
		if walkable.get_cellv(pos) == -1:
			set_cellv(pos, -1)
			outside_ground_count += 1
		else:
			create_pawn(idx, pos)
	print("%s Pawns generated" %_pawns.size())
	if outside_ground_count:
		print("Removed %s pawns outside of walkable tilemap" % outside_ground_count)
	validate_tilemap_and_pawns_equal()

func create_pawn(index: int, pos: Vector2) -> void:
	var new_pawn = DataLoader.create_pawn(index, pos, self)
	new_pawn.connect("pawn_died", self, "_on_pawn_destroyed")
	_pawns[pos] = new_pawn
	set_cellv(pos, index)
	emit_signal("pawn_created", index, pos)

func get_pawn_id_at(pos) -> int:
	return get_cellv(pos)

func get_pawn_at(pos) -> Pawn:
	return _pawns.get(pos)

func destroy_pawn(pos: Vector2) -> void:
	var index = get_pawn_id_at(pos)
	if index == -1:
		print("HEY! Trying to destoy non existent pawn on position %s" %pos)
		return
	set_cellv(pos, -1)
	var pawn = _pawns[pos]
	pawn.destroy()
#	remove_child(pawn)
	_pawns.erase(pos)
	emit_signal("pawn_destroyed", index, pos)

func replace_pawn(index: int, pos: Vector2) -> void:
	destroy_pawn(pos)
	create_pawn(index, pos)

func move_pawn(pos_from :Vector2, pos_to :Vector2) -> void:
	var dir := pos_to - pos_from
	if dir == Vector2.ZERO:
		return
	var pawn :Pawn = _pawns[pos_from]
	var index = pawn.tile_index
	if get_pawn_id_at(pos_to) > -1:
		print("HEY! Pawn trying to move to occupied position %s" %pos_to)
		return
	# Validate tilemap
	assert(get_pawn_id_at(pos_from) == pawn.tile_index, 
			"Could not find tile %s at position %s" % [index, pos_from]
	)
	# Validate dict
	assert(_pawns.has(pos_from),
			"Could not find pawn %s at position %s" % [index, pos_from]
	)
	# Move in tilemap
	set_cellv(pos_from, -1)
	set_cellv(pos_to, pawn.tile_index)
	# Move in dict
	_pawns.erase(pos_from)
	_pawns[pos_to] = pawn
	pawn.set_position(pos_to)
	emit_signal("pawn_moved", index, pos_from, pos_to)
	validate_tilemap_and_pawns_equal()

func update_all(input: Dictionary) -> void:
	input["pawn_controller"] = self
	for pawn in _pawns.values():
		pawn.update_state_machine(input)

func set_debug_mode(value) -> void:
	self_modulate.a = 1.0 if value else 0.0
	var pawn_modulate = 0.0 if value else 1.0
	for c in get_children():
		c.modulate.a = pawn_modulate
	__tilemap_self_modulate_bug_dirty_fix()
	print("Debug mode %s" % value)

func _on_pawn_destroyed(pawn) -> void:
	destroy_pawn(pawn.grid_position)

func validate_tilemap_and_pawns_equal():
	var grid_positions = get_used_cells()
	if not len(grid_positions) == get_child_count():
		# Check for duplicate Pawn positions
		var pawn_positions = []
		for pawn in get_children():
			if pawn.grid_position in pawn_positions:
				print("Duplicate position! %s" %pawn.grid_position)
				pawn.modulate = Rng.rand_rgb()
			else:
				pawn_positions.append(pawn.grid_position)
		if get_child_count() > len(grid_positions):
			for c in get_children():
				if not c.grid_position in grid_positions:
					print("Pawn %s is not on tilemap!" %c.name)
		else:
			pawn_positions = []
			for c in get_children():
				pawn_positions.append(c.grid_position)
			for pos in grid_positions:
				if not pos in pawn_positions:
					print("Pawn does not exist on position %s" %pos)
	var child_count = get_child_count()
	# BELOW SHOULD ALWAYS BE TRUE!
	assert(len(grid_positions) == len(_pawns.keys())
			and len(grid_positions) == get_child_count())
	for pos in grid_positions:
		assert(_pawns.has(pos))
		assert(_pawns[pos].grid_position == pos)

func __tilemap_self_modulate_bug_dirty_fix():
	# https://github.com/godotengine/godot/issues/31413
	var _temp_tiles = {}
	for pos in get_used_cells():
		_temp_tiles[pos] = get_cellv(pos)
	clear()
	for pos in _temp_tiles.keys():
		set_cellv(pos, _temp_tiles[pos])
