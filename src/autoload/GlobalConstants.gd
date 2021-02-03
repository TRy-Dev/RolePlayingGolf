extends Node

const TILE_SIZE := 16
const MOVE_TIME := 0.2
const HALF_TILE := Vector2(0.5 * TILE_SIZE, 0.5 * TILE_SIZE)

func grid_to_world(pos: Vector2) -> Vector2:
	return pos * TILE_SIZE + HALF_TILE

#func world_to_grid(pos: Vector2) -> Vector2:
#
