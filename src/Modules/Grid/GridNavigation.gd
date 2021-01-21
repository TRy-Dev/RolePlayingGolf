extends Node

class_name GridNavigation

signal nav_grid_updated(a_star)

var a_star := AStar2D.new()

func _ready():
	pass
	connect("nav_grid_updated", $DebugGridNavigation, "_on_nav_grid_updated")

func initialize(walkable: TileMap) -> void:
	var cells = walkable.get_used_cells()
	if len(cells) > a_star.get_point_capacity():
		a_star.reserve_space(len(cells))
	for pos in cells:
		# Add point
		var p_id = a_star.get_available_point_id()
		a_star.add_point(p_id, pos)
		# Add connections to left and up neighbours
		var neighbors = [Vector2(pos.x - 1, pos.y), Vector2(pos.x, pos.y - 1)]
		for n_pos in neighbors:
			if walkable.get_cellv(n_pos) > -1:
				var n_id = _get_point_at(n_pos, false)
				a_star.connect_points(p_id, n_id)
	emit_signal("nav_grid_updated", a_star)

func get_nav_path(pos_from: Vector2, pos_to: Vector2) -> Array:
	var id_from = _get_point_at(pos_from, false)
	var id_to = _get_point_at(pos_to, false)
	var path = a_star.get_point_path(id_from, id_to)
	return path

func _get_point_at(pos: Vector2, include_disabled: bool) -> int:
	return a_star.get_closest_point(pos, include_disabled)

## GOLF Specific code - should be moved to inheriting class?

func _on_pawn_created(index, pos):
	var pt = _get_point_at(pos, false)
	a_star.set_point_disabled(pt, true)
	emit_signal("nav_grid_updated", a_star)

func _on_pawn_destroyed(index, pos):
	var pt = _get_point_at(pos, true)
	print(a_star.is_point_disabled(pt))
	a_star.set_point_disabled(pt, false)
	print(a_star.is_point_disabled(pt))
	emit_signal("nav_grid_updated", a_star)

func _on_pawn_moved(index, pos_from, pos_to):
	var pt_from = _get_point_at(pos_from, true)
	var pt_to = _get_point_at(pos_to, false)
	a_star.set_point_disabled(pt_from, false)
	# We assume that only selected pawn can be moved and trigger this function
	a_star.set_point_disabled(pt_to, false)
#	a_star.set_point_disabled(pt_to, true)
	emit_signal("nav_grid_updated", a_star)

func _on_pawn_selected(previous: Pawn, current: Pawn) -> void:
	if previous:
		var pt = _get_point_at(previous.grid_position, false)
		a_star.set_point_disabled(pt, true)
	if current:
		var pt = _get_point_at(current.grid_position, true)
		a_star.set_point_disabled(pt, false)
	emit_signal("nav_grid_updated", a_star)
