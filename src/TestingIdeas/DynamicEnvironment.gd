extends TileMap

class_name DynamicEnvironment

func create_dynamic_tile(tile_id: int, pos: Vector2):
	var new_tile = DataLoader.create_dynamic_env_tile(tile_id, pos, self)
	return new_tile
