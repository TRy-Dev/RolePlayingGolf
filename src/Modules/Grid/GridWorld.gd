extends Node2D

onready var _pawns = $PawnController
onready var _environment = $Environment
onready var _navigation :GridNavigation = $GridNavigation

func _ready():
	_environment.initialize()
	_navigation.initialize(_environment.get_walkable_tilemap())
	_pawns.connect("pawn_created", _navigation, "_on_pawn_created")
	_pawns.connect("pawn_destroyed", _navigation, "_on_pawn_destroyed")
	_pawns.connect("pawn_moved", _navigation, "_on_pawn_moved")
	_pawns.initialize(_environment.get_walkable_tilemap())
	_pawns.set_debug_mode(false)

func get_nav_path(pos_from: Vector2, pos_to: Vector2) -> Array:
#	pos_from = world_to_grid(pos_from)
#	pos_to = world_to_grid(pos_to)
	var grid_points = _navigation.get_nav_path(pos_from, pos_to)
#	var world_points = []
#	for p in grid_points:
#		world_points.append(_walkable_tilemap.map_to_world(p))
	return grid_points

func _on_pawn_selected(previous: Pawn, current: Pawn) -> void:
	_navigation._on_pawn_selected(previous, current)

func update_pawns() -> void:
	_pawns.update_all(_navigation)

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
