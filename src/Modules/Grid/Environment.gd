extends Node2D

onready var _ground :TileMap = $Ground
onready var _outer_colliders :TileMap = $OuterColliders


func initialize() -> void:
	_initialize_colliders()

func get_walkable_tilemap() -> TileMap:
	return _ground

func _initialize_colliders() -> void:
	var borders = []
	for cell_pos in _ground.get_used_cells():
		for dir in Math.CARDINAL_DIRECTIONS + Math.CROSS_DIRECTIONS:
			var pos = cell_pos + dir
			if _ground.get_cellv(pos) == -1:
				borders.append(pos)
	# Borders have duplicates!
	for b in borders:
		_outer_colliders.set_cellv(b, 1)
