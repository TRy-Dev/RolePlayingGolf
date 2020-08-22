extends TileMap

const MASK_ID = 0

export(bool) var spawn_trees = false
export(bool) var spawn_grass = false
export(bool) var spawn_dirt = false

export(float, 0.0, 1.0) var NO_TREE_CHANCE = 1.0
export(float, 0.0, 1.0) var NO_GRASS_CHANCE = 1.0
export(float, 0.0, 1.0) var NO_DIRT_CHANCE = 1.0
export(bool) var change_seed = false

var trees = [1,2,3,4,5,6,7,8]
var grass = [9,10,11,12]
var dirt = [13,14,15,16]

const SEED = 207198184


var noise = OpenSimplexNoise.new()
var rng = RandomNumberGenerator.new()

const TREE_OFFSET = Vector2(-1234, 6432)
const GRASS_OFFSET = Vector2(209654, -1184560)
const DIRT_OFFSET = Vector2()
const POS_MULT = 1000

func _ready() -> void:
	modulate = Color.white
	
	rng.seed = SEED
	noise.seed = SEED
	noise.octaves = 4
	noise.period = 2.0
	noise.persistence = 0.8
	
	if not spawn_trees:
		NO_TREE_CHANCE = 1.0
	if not spawn_grass:
		NO_GRASS_CHANCE = 1.0
	if not spawn_dirt:
		NO_DIRT_CHANCE = 1.0
	
	randomize_trees()

func randomize_trees():
	if change_seed:
		noise.seed = SEED + 1
	for pos in get_used_cells_by_id(MASK_ID):
		var cell = get_cellv(pos)
		if rand_at(pos * POS_MULT + TREE_OFFSET) < NO_TREE_CHANCE:
			if rand_at(pos * POS_MULT + GRASS_OFFSET) < NO_GRASS_CHANCE:
				if rand_at(pos * POS_MULT + DIRT_OFFSET) < NO_DIRT_CHANCE:
					set_cellv(pos, -1)
				elif spawn_dirt:
					set_cellv(pos, random_from_arr(dirt))
			elif spawn_grass:
				set_cellv(pos, random_from_arr(grass))
			else:
				set_cellv(pos, -1)
		elif spawn_trees:
			set_cellv(pos, random_from_arr(trees))
		else:
			set_cellv(pos, -1)


func rand_at(pos) -> float:
	var val = noise.get_noise_2d(pos.x, pos.y)
	val *= 0.5
	val += 0.5
	return val

func random_from_arr(arr):
	if len(arr) < 1:
		return -1
	return arr[rng.randi_range(0, len(arr) - 1)]


func _debug_noise():
	var min_val = 2.0
	var max_val = -2.0
	for pos in get_used_cells_by_id(MASK_ID):
		var val = rand_at(pos)
		if val < min_val:
			min_val = val
		if val > max_val:
			max_val = val
	print(min_val)
	print(max_val)
