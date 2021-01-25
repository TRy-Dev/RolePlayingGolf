extends Node2D

onready var _env = $EnvironmentTest

var debug_tile_prefab = preload("res://src/TestingIdeas/DebugTile.tscn")

func _ready():
	_env.initialize()
	var tilemap = _env.get_walkable_tilemap()
	var half_tile_size = tilemap.cell_size * 0.5
	
#	for pos in tilemap.get_used_cells():
#		_add_debug_tile(tilemap.map_to_world(pos) + half_tile_size)

#	var min_val = 1
#	var max_val = 0
#	var loops = pow(10, 6)
#	var noise_scale = 1000
#	for i in range(loops):
#		var noise = Rng.noise(i * noise_scale)
#		if noise < min_val:
#			min_val = noise
#		if noise > max_val:
#			max_val = noise
#	print("min: %s. max %s" %[min_val, max_val])

var NOISE_OFFSET = 10000
var NOISE_SCALE = 0.3
var START_COLOR = Color8(122, 68, 74)
var END_COLOR = Color8(207, 198, 184)

func _add_debug_tile(pos: Vector2) -> void:
	var tile = debug_tile_prefab.instance()
	tile.global_position = pos
	pos *= NOISE_SCALE
	var noise = Rng.noise(pos.x, pos.y, NOISE_OFFSET)
	tile.modulate = START_COLOR.linear_interpolate(END_COLOR, noise)
	add_child(tile)
