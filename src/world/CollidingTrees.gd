extends TileMap


var tree_ids = [1,2,3,4,5,6,7,8]

var rng = RandomNumberGenerator.new()

const SEED = 8


func _ready() -> void:
	if not tree_ids:
		return
	rng.seed = SEED
	for pos in get_used_cells():
		var rand_idx = rng.randi_range(0, len(tree_ids) - 1)
		set_cellv(pos, tree_ids[rand_idx])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
