extends Node2D

var nav_points := []

export(Resource) var font_resource

func _draw():
	for c in get_children():
		c.free()
	for point in nav_points:
		draw_circle(point.position, 1.0, Color.red if point.disabled else Color.green)
#		_draw_label("%s:%s" % [point.grid_pos.x, point.grid_pos.y], point.position)
		if not point.disabled:
			for neigh_pos in point.neighbors:
				draw_line(point.position, neigh_pos, Color.blue)

func _draw_label(text: String, pos: Vector2):
	var label = Label.new()
	label.rect_position = pos + Vector2(0, -4)
	label.grow_vertical = Control.GROW_DIRECTION_BOTH
	label.grow_horizontal = Control.GROW_DIRECTION_BOTH
	label.rect_size = Vector2.ZERO
	label.add_font_override("Kenney Small", font_resource)
	label.text = text
	add_child(label)

func _on_nav_grid_updated(a_star):
	nav_points = []
	var tile_size = GlobalConstants.TILE_SIZE
	for p_id in a_star.get_points():
		var point := {}
		var pos_grid = a_star.get_point_position(p_id)
		var pos_world = tile_size * (pos_grid + 0.5 * Vector2.ONE)
		point["position"] = pos_world
		point["grid_pos"] = pos_grid
		var neighbor_points = []
		for conn_id in a_star.get_point_connections(p_id):
			var neigh_pos_grid = a_star.get_point_position(conn_id)
			var neigh_pos_world = tile_size * (neigh_pos_grid + 0.5 * Vector2.ONE)
			neighbor_points.append(neigh_pos_world)
		point["neighbors"] = neighbor_points
		point["disabled"] = a_star.is_point_disabled(p_id)
		nav_points.append(point)
	update()

