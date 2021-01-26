extends Node2D

var debug_tile_prefab = preload("res://src/TestingIdeas/DebugTile.tscn")

var start_pos = Vector2(-10, -10)
var resolution = Vector2(120, 120)

func _ready():
	for y in range(resolution.y):
		for x in range(resolution.x):
			var w_pos = (start_pos + Vector2(x, y)) * GlobalConstants.TILE_SIZE
			_add_debug_tile(w_pos)

var NOISE_OFFSET = 10000
var NOISE_SCALE = 1
var START_COLOR = Color8(122, 68, 74)
var END_COLOR = Color8(56, 217, 115)

func _add_debug_tile(pos: Vector2) -> void:
	var tile = debug_tile_prefab.instance()
	tile.global_position = pos
	pos *= NOISE_SCALE
	var noise = Rng.noise(pos.x, pos.y, NOISE_OFFSET)
	tile.modulate = START_COLOR.linear_interpolate(END_COLOR, noise)
	add_child(tile)
