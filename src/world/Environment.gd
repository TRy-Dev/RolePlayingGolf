extends TileMap

const MASK_ID = 16

var trees = [8, 9, 10, 11, 12, 13, 14, 15]

const SEED = 207198184
const NO_TREE_CHANCE = 0.5

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.seed = SEED
	randomize_trees()

func randomize_trees():
	for pos in get_used_cells_by_id(MASK_ID):
		var cell = get_cellv(pos)
		if rng.randf() < NO_TREE_CHANCE:
			set_cellv(pos, -1)
		else:
			set_cellv(pos, random_tree())
			
func random_tree():
	return trees[rng.randi_range(0, len(trees) - 1)]
