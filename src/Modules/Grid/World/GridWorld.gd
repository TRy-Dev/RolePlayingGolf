extends Node2D

class_name GridWorld

onready var _pawns = $PawnController
onready var _environment = $Environment
onready var _dynamic_environment :DynamicEnvironment = $DynamicEnvironment
onready var _navigation :GridNavigation = $GridNavigation

var player_last_grid_pos = null

func _ready():
	_navigation.initialize(_environment.get_walkable_tilemap())
	_pawns.connect("pawn_created", _navigation, "_on_pawn_created")
	_pawns.connect("pawn_destroyed", _navigation, "_on_pawn_destroyed")
	_pawns.connect("pawn_moved", _navigation, "_on_pawn_moved")
	_pawns.set_debug_mode(false)
	_pawns.initialize(_environment.get_walkable_tilemap())

func get_nav_path(pos_from: Vector2, pos_to: Vector2) -> Array:
	_navigation.set_node_at_disabled(pos_from, false)
	var grid_points = _navigation.get_nav_path(pos_from, pos_to)
	_navigation.set_node_at_disabled(pos_from, true)
	return grid_points

func update_pawns() -> void:
	var input = {
		"world": self,
		"dynamic_environment": _dynamic_environment
	}
	_pawns.update_all(input)

func update_player_position(pos: Vector2) -> void:
	var grid_pos = _pawns.world_to_map(pos)
	if grid_pos != player_last_grid_pos:
		if player_last_grid_pos != null:
			_navigation.set_node_at_disabled(player_last_grid_pos, false)
		_navigation.set_node_at_disabled(grid_pos, true)
		player_last_grid_pos = grid_pos

# TEMPORARY

func is_position_unoccupied(pos: Vector2) -> bool:
	if not _environment.is_position_walkable(pos):
		return false
	if _pawns.get_pawn_id_at(pos) > -1:
		return false
	if player_last_grid_pos == pos:
		return false
	for c in $RatHoleContainer.get_children():
		if c.grid_position == pos:
			return false
	return true

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
