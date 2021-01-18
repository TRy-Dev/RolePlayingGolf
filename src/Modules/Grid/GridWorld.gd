extends Node2D

signal pawn_created(pos, index)
signal pawn_destroyed(pos, index)

onready var _env = $Environment
onready var _pawns_tilemap :TileMap = $Pawns
onready var _pawn_container :Node2D = $PawnContainer #$Environment/WallsInner

# Dict Vector2 -> Pawn
var _pawns := {}

var player :Actor = null

func _ready():
	_init_pawns()
	set_debug_mode(false)

func _init_pawns() -> void:
	var pawns_grid_positions = _pawns_tilemap.get_used_cells()
	for pos in pawns_grid_positions:
		var idx = get_pawn_id_at(pos)
		create_pawn(idx, pos)
	validate_tilemap_and_pawns_equal()

func validate_tilemap_and_pawns_equal():
	var grid_positions = _pawns_tilemap.get_used_cells()
	assert(len(grid_positions) == len(_pawns.keys()))
	for pos in grid_positions:
		assert(_pawns.has(pos))
		assert(_pawns[pos].get_grid_pos() == pos)
#		yield(get_tree().create_timer(GlobalConstants.MOVE_TIME), "timeout")
		assert(_pawns_tilemap.world_to_map(_pawns[pos].global_position) == pos)

func create_pawn(index: int, pos: Vector2) -> void:
	var new_pawn = GameData.get_pawn_instance_by_id(index, pos, _pawn_container)
	if new_pawn is Actor:
		player = new_pawn
	_pawns[pos] = new_pawn
	_pawns_tilemap.set_cellv(pos, index)
	emit_signal("pawn_created", pos, index)

func destroy_pawn(pos: Vector2) -> void:
	var index = _pawns_tilemap.get_cellv(pos)
	_pawns_tilemap.set_cellv(pos, -1)
	var pawn = _pawns[pos]
	pawn.destroy()
	_pawn_container.remove_child(pawn)
	_pawns.erase(pos)
	emit_signal("pawn_destroyed", pos, index)

func replace_pawn(index: int, pos: Vector2) -> void:
	destroy_pawn(pos)
	create_pawn(index, pos)

func is_tile_walkable(pos) -> bool:
	return _env.is_tile_walkable(pos)

func get_pawn_id_at(pos) -> int:
	return _pawns_tilemap.get_cellv(pos)

func get_pawn_at(pos) -> Pawn:
	return _pawns.get(pos)

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
	pawn.set_pos(pos_to)
	
	emit_signal("pawn_destroyed", pos_from, index)
	emit_signal("pawn_created", pos_to, index)

func set_debug_mode(value) -> void:
	_pawns_tilemap.visible = value
	_pawn_container.visible = !value
	print("Debug mode %s" % _pawns_tilemap.visible)

func toggle_debug() -> void:
	_pawns_tilemap.visible = !_pawns_tilemap.visible
	_pawn_container.visible = !_pawn_container.visible
	print("Debug mode %s" % _pawns_tilemap.visible)

func env_world_to_map(pos) -> Vector2:
	return _env.world_to_map(pos)
	
func set_env_tile(pos, id) -> void:
	_env.set_cell_at(pos, id)

func save_state(save_game: Resource):
	_env.save_state(save_game)
	save_game.data["pawns"] = {}
	var pawns_grid_positions = _pawns_tilemap.get_used_cells()
	for pos in pawns_grid_positions:
		save_game.data["pawns"][pos] = _pawns_tilemap.get_cellv(pos)

func load_state(save_game: Resource):
	_env.load_state(save_game)
	_pawns_tilemap.clear()
	_pawns = {}
	for c in _pawn_container.get_children():
		c.queue_free()
	for key in save_game.data["pawns"]:
		var idx = save_game.data["pawns"][key]
		create_pawn(idx, key)
	validate_tilemap_and_pawns_equal()
