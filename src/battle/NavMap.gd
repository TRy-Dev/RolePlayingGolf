extends TileMap

onready var colliders = owner

func _ready() -> void:
	modulate.a = 0.0
	var collider_cells = colliders.get_used_cells()
	var border_cells = get_border_cells(collider_cells)
	for pos in collider_cells:
		if not pos in border_cells:
			_remove_nav_at(colliders.map_to_world(pos))

func get_border_cells(cells) -> Array:
	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF
	for c in cells:
		if c.x < min_x:
			min_x = c.x
		if c.x > max_x:
			max_x = c.x
		if c.y < min_y:
			min_y = c.y
		if c.y > max_y:
			max_y = c.y
	
	var extents_x = [min_x, max_x]
	var extents_y = [min_y, max_y]
	var border_cells = []
	
	for c in cells:
		if c.x in extents_x:
			border_cells.append(c)
		elif c.y in extents_y:
			border_cells.append(c)
	
	return border_cells
	
func _remove_nav_at(world_pos):
	# remove inner
	var lm = GameData.TILE_SIZE - 1
	var lp = GameData.TILE_SIZE + 1
	var lhp = 0.5 * GameData.TILE_SIZE + 1
	var offsets = [
		# inner
		Vector2(1, 1),
		Vector2(lm, 1),
		Vector2(1, lm),
		Vector2(lm, lm),
		# outer
		Vector2(-1, 1),
		Vector2(-1, -1),
		Vector2(1, -1),
		Vector2(lm, -1),
		Vector2(lp, -1),
		Vector2(lp, 1),
		Vector2(-1 , lhp),
		Vector2(lp , lhp),
		Vector2(-1 , lp),
		Vector2(1 , lp),
		Vector2(lm , lp),
		Vector2(lp , lp),
	]

	for off in offsets:
		var grid_pos = world_to_map(world_pos + off)
		set_cellv(grid_pos, -1)
