extends Node2D

onready var _ground :TileMap = $Ground

class Dir:
	const UP = Vector2(0, -1)
	const DN = Vector2(0, 1)
	const LT = Vector2(-1, 0)
	const RT = Vector2(1, 0)

	const UL = Vector2(-1, -1)
	const UR = Vector2(1, -1)
	const DL = Vector2(-1, 1)
	const DR = Vector2(1, 1)

var INNER_TILES_MASK = {
	0: {
		"ground": [Dir.UP, Dir.RT, Dir.DN],
		"no-ground": [Dir.LT]
	},
	1: {
		"ground": [Dir.LT, Dir.RT, Dir.DN],
		"no-ground": [Dir.UP]
	},
	2: {
		"ground": [Dir.LT, Dir.UP, Dir.DN],
		"no-ground": [Dir.RT]
	},
	3: {
		"ground": [Dir.LT, Dir.UP, Dir.RT],
		"no-ground": [Dir.DN]
	},
	4: {
		"ground": [Dir.DN, Dir.RT],
		"no-ground": [Dir.LT, Dir.UP]
	},
	5: {
		"ground": [Dir.DN, Dir.LT],
		"no-ground": [Dir.RT, Dir.UP]
	},
	6: {
		"ground": [Dir.UP, Dir.LT],
		"no-ground": [Dir.RT, Dir.DN]
	},
	7: {
		"ground": [Dir.UP, Dir.RT],
		"no-ground": [Dir.LT, Dir.DN]
	},
	8: {
		"ground": [Dir.DN],
		"no-ground": [Dir.UP, Dir.LT, Dir.RT]
	},
	9: {
		"ground": [Dir.LT],
		"no-ground": [Dir.UP, Dir.DN, Dir.RT]
	},
	10: {
		"ground": [Dir.UP],
		"no-ground": [Dir.LT, Dir.DN, Dir.RT]
	},
	11: {
		"ground": [Dir.RT],
		"no-ground": [Dir.LT, Dir.DN, Dir.UP]
	},
	12: {
		"ground": [Dir.DN, Dir.UP],
		"no-ground": [Dir.LT, Dir.RT]
	},
	13: {
		"ground": [Dir.LT, Dir.RT],
		"no-ground": [Dir.DN, Dir.UP]
	},
	14: {
		"ground": [],
		"no-ground": [Dir.RT, Dir.LT, Dir.DN, Dir.UP]
	},
}

var OUTER_TILES_MASK = {
	0: {
		"ground": [Dir.LT],
		"no-ground": [Dir.RT, Dir.UP, Dir.DN]
	},
	1: {
		"ground": [Dir.UP],
		"no-ground": [Dir.DN, Dir.LT, Dir.RT]
	},
	2: {
		"ground": [Dir.RT],
		"no-ground": [Dir.LT, Dir.UP, Dir.DN]
	},
	3: {
		"ground": [Dir.DN],
		"no-ground": [Dir.LT, Dir.UP, Dir.RT]
	},
	4: {
		"ground": [Dir.LT, Dir.UP],
		"no-ground": [Dir.DN, Dir.RT]
	},
	5: {
		"ground": [Dir.RT, Dir.UP],
		"no-ground": [Dir.DN, Dir.LT]
	},
	6: {
		"ground": [Dir.RT, Dir.DN],
		"no-ground": [Dir.UP, Dir.LT]
	},
	7: {
		"ground": [Dir.LT, Dir.DN],
		"no-ground": [Dir.UP, Dir.RT]
	},
	8: {
		"ground": [Dir.LT, Dir.RT, Dir.UP],
		"no-ground": [Dir.DN]
	},
	9: {
		"ground": [Dir.DN, Dir.RT, Dir.UP],
		"no-ground": [Dir.LT]
	},
	10: {
		"ground": [Dir.DN, Dir.RT, Dir.LT],
		"no-ground": [Dir.UP]
	},
	11: {
		"ground": [Dir.DN, Dir.UP, Dir.LT],
		"no-ground": [Dir.RT]
	},
	12: {
		"ground": [Dir.LT, Dir.RT],
		"no-ground": [Dir.DN, Dir.UP]
	},
	13: {
		"ground": [Dir.DN, Dir.UP],
		"no-ground": [Dir.LT, Dir.RT]
	},
	14: {
		"ground": [Dir.DN, Dir.UP, Dir.LT, Dir.RT],
		"no-ground": []
	},
	# 15 - empty; padding
	# Cross
	16: {
		"ground": [Dir.UL],
		"no-ground": [Dir.UR, Dir.DR, Dir.DL]
	},
	17: {
		"ground": [Dir.UR],
		"no-ground": [Dir.UL, Dir.DR, Dir.DL]
	},
	18: {
		"ground": [Dir.DR],
		"no-ground": [Dir.UL, Dir.UR, Dir.DL]
	},
	19: {
		"ground": [Dir.DL],
		"no-ground": [Dir.UL, Dir.UR, Dir.DR]
	},
	20: {
		"ground": [Dir.UL, Dir.UR],
		"no-ground": [Dir.DL, Dir.DR]
	},
	21: {
		"ground": [Dir.DR, Dir.UR],
		"no-ground": [Dir.DL, Dir.UL]
	},
	22: {
		"ground": [Dir.DR, Dir.DL],
		"no-ground": [Dir.UR, Dir.UL]
	},
	23: {
		"ground": [Dir.UL, Dir.DL],
		"no-ground": [Dir.UR, Dir.DR]
	},
	24: {
		"ground": [Dir.UL, Dir.UR, Dir.DR],
		"no-ground": [Dir.DL]
	},
	25: {
		"ground": [Dir.DL, Dir.UR, Dir.DR],
		"no-ground": [Dir.UL]
	},
	26: {
		"ground": [Dir.DL, Dir.UL, Dir.DR],
		"no-ground": [Dir.UR]
	},
	27: {
		"ground": [Dir.DL, Dir.UL, Dir.UR],
		"no-ground": [Dir.DR]
	},
	28: {
		"ground": [Dir.UL, Dir.DR],
		"no-ground": [Dir.DL, Dir.UR]
	},
	29: {
		"ground": [Dir.DL, Dir.UR],
		"no-ground": [Dir.UL, Dir.DR]
	},
	30: {
		"ground": [Dir.DL, Dir.UR, Dir.UL, Dir.DR],
		"no-ground": []
	},
}

func _ready() -> void:
#	$Grid.visible = true
	_generate_walls()

func _generate_walls():
	var ground_cells = _ground.get_used_cells()
	# Inner walls
	var w_inner = $WallsInner
	w_inner.clear()
	for cell_pos in ground_cells:
		for id in INNER_TILES_MASK.keys():
			var mask = INNER_TILES_MASK[id]
			var mask_not_matched = false
			for dir in mask["ground"]:
				if not (cell_pos + dir) in ground_cells:
					mask_not_matched = true
					break
			if mask_not_matched:
				continue
			for dir in mask["no-ground"]:
				if (cell_pos + dir) in ground_cells:
					mask_not_matched = true
					break
			if mask_not_matched:
				continue
			w_inner.set_cellv(cell_pos, id)
			break
			
	# Outer walls
	var w_outer = $WallsOuter
	w_outer.clear()
	for cell_pos in ground_cells:
		for dir in [Dir.RT, Dir.LT, Dir.DN, Dir.UP, Dir.UL, Dir.UR, Dir.DL, Dir.DR]:
			var neighbor_pos = cell_pos + dir
			if not neighbor_pos in ground_cells:
				for id in OUTER_TILES_MASK.keys():
					var mask = OUTER_TILES_MASK[id]
					var mask_not_matched = false
					for d in mask["ground"]:
						if not (neighbor_pos + d) in ground_cells:
							mask_not_matched = true
							break
					if mask_not_matched:
						continue
					for d in mask["no-ground"]:
						if (neighbor_pos + d) in ground_cells:
							mask_not_matched = true
							break
					if mask_not_matched:
						continue
					w_outer.set_cellv(neighbor_pos, id)
					break

func is_tile_walkable(pos :Vector2) -> bool:
	return _ground.get_cellv(pos) != -1

func set_cell_at(pos: Vector2, id: int) -> void:
	_ground.set_cellv(pos, id)

func save_state(save_game: Resource):
	save_game.data["env-ground"] = {}
	for pos in _ground.get_used_cells():
		save_game.data["env-ground"][pos] = _ground.get_cellv(pos)
	
func load_state(save_game: Resource):
	for pos in save_game.data["env-ground"]:
		var idx = save_game.data["env-ground"][pos]
		_ground.set_cellv(pos, idx)
	_generate_walls()
