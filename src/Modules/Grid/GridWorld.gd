extends Node2D

signal pawn_created(index, pos)
signal pawn_destroyed(index, pos)
signal pawn_moved(index, pos_from, pos_to)

onready var _pawns_tilemap :TileMap = $Pawns
#onready var _walkable_tilemap :TileMap = $Walkable
#onready var _colliders_tilemap :TileMap = $Colliders
onready var _navigation :GridNavigation = $GridNavigation
onready var _pawn_container :Node2D = $PawnContainer


# Dict Vector2 -> Pawn
var _pawns := {}

func _ready():
	_navigation.initialize($Walkable)
	connect("pawn_created", _navigation, "_on_pawn_created")
	connect("pawn_destroyed", _navigation, "_on_pawn_destroyed")
	connect("pawn_moved", _navigation, "_on_pawn_moved")
	
	_initialize_pawns()

	set_debug_mode(false)

func _initialize_pawns() -> void:
	var pawns_grid_positions = _pawns_tilemap.get_used_cells()
	for pos in pawns_grid_positions:
		var idx = get_pawn_id_at(pos)
		create_pawn(idx, pos)
	validate_tilemap_and_pawns_equal()

func _initialize_colliders() -> void:
	pass
	# To be moved to GridEnvironment
#	var borders = []
#	for cell_pos in _walkable_tilemap.get_used_cells():
#		for card_dir in Math.CARDINAL_DIRECTIONS + Math.CROSS_DIRECTIONS:
#			var pos = cell_pos + card_dir
#			if _walkable_tilemap.get_cellv(pos) == -1:
#				borders.append(pos)
#	# Borders have duplicates!
#	for b in borders:
#		_colliders_tilemap.set_cellv(b, 0)

func validate_tilemap_and_pawns_equal():
	var grid_positions = _pawns_tilemap.get_used_cells()
	assert(len(grid_positions) == len(_pawns.keys())
			and len(grid_positions) == _pawn_container.get_child_count())
	for pos in grid_positions:
		assert(_pawns.has(pos))
		assert(_pawns[pos].grid_position == pos)
		assert(_pawns_tilemap.world_to_map(_pawns[pos].global_position) == pos)

func get_pawn_id_at(pos) -> int:
	return _pawns_tilemap.get_cellv(pos)

func get_pawn_at(pos) -> Pawn:
	return _pawns.get(pos)

func create_pawn(index: int, pos: Vector2) -> void:
	var new_pawn = GameData.get_pawn_instance_by_id(index, pos, _pawn_container)
	_pawns[pos] = new_pawn
	_pawns_tilemap.set_cellv(pos, index)
	emit_signal("pawn_created", index, pos)

func destroy_pawn(pos: Vector2) -> void:
	var index = _pawns_tilemap.get_cellv(pos)
	_pawns_tilemap.set_cellv(pos, -1)
	var pawn = _pawns[pos]
	pawn.destroy()
	_pawn_container.remove_child(pawn)
	_pawns.erase(pos)
	emit_signal("pawn_destroyed", index, pos)

func replace_pawn(index: int, pos: Vector2) -> void:
	destroy_pawn(pos)
	create_pawn(index, pos)

func move_pawn(pos_from :Vector2, pos_to :Vector2) -> void:
	var pawn = _pawns[pos_from]
	var index = pawn.tile_index
	# Validate tilemap
	assert(get_pawn_id_at(pos_from) == pawn.tile_index, 
			"Could not find tile %s at position %s" % [index, pos_from]
	)
	# Validate dict
	assert(_pawns.has(pos_from),
			"Could not find pawn %s at position %s" % [index, pos_from]
	)
	# Move in tilemap
	_pawns_tilemap.set_cellv(pos_from, -1)
	_pawns_tilemap.set_cellv(pos_to, pawn.tile_index)
	# Move in dict
	_pawns.erase(pos_from)
	_pawns[pos_to] = pawn
	pawn.set_position(pos_to)
	
	emit_signal("pawn_moved", index, pos_from, pos_to)
	yield(get_tree().create_timer(GlobalConstants.MOVE_TIME), "timeout")
	validate_tilemap_and_pawns_equal()


func set_debug_mode(value) -> void:
	_pawns_tilemap.visible = value
	_pawn_container.visible = !value
	print("Debug mode %s" % value)

#func toggle_debug() -> void:
#	_pawns_tilemap.visible = !_pawns_tilemap.visible
#	_pawn_container.visible = !_pawn_container.visible
#	print("Debug mode %s" % _pawns_tilemap.visible)

## Added for GOLF

func get_nav_path(pos_from: Vector2, pos_to: Vector2) -> Array:
#	pos_from = world_to_grid(pos_from)
#	pos_to = world_to_grid(pos_to)
	var grid_points = _navigation.get_nav_path(pos_from, pos_to)
#	var world_points = []
#	for p in grid_points:
#		world_points.append(_walkable_tilemap.map_to_world(p))
	return grid_points

#func grid_to_world(grid_pos: Vector2) -> Vector2:
#	return _walkable_tilemap.map_to_world(grid_pos)
#
#func world_to_grid(world_pos: Vector2) -> Vector2:
#	return _walkable_tilemap.world_to_map(world_pos)

func _on_pawn_selected(previous: Pawn, current: Pawn) -> void:
	_navigation._on_pawn_selected(previous, current)


#func set_env_tile(pos, id) -> void:
#	_env.set_cell_at(pos, id)

#func save_state(save_game: Resource):
#	_env.save_state(save_game)
#	save_game.data["pawns"] = {}
#	var pawns_grid_positions = _pawns_tilemap.get_used_cells()
#	for pos in pawns_grid_positions:
#		save_game.data["pawns"][pos] = _pawns_tilemap.get_cellv(pos)

#func load_state(save_game: Resource):
#	_env.load_state(save_game)
#	_pawns_tilemap.clear()
#	_pawns = {}
#	for c in _pawn_container.get_children():
#		c.queue_free()
#	for key in save_game.data["pawns"]:
#		var idx = save_game.data["pawns"][key]
#		create_pawn(idx, key)
#	validate_tilemap_and_pawns_equal()
