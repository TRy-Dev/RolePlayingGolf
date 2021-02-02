extends Node

# Array of pawns -> prefab scene
var _pawns = {
	0: preload("res://src/Pawns/Peasant.tscn"),
	1: preload("res://src/TestingIdeas/RatHunt/DirtRat.tscn"),
}

var _dynamic_environment_tiles = {
	0: preload("res://src/TestingIdeas/RatHunt/RatHole.tscn"),
}

func create_pawn(pawn_id: int, pos: Vector2, parent) -> Pawn:
	var pawn = _pawns[pawn_id].instance()
	parent.add_child(pawn)
	pawn.initialize(pos, pawn_id)
	return pawn

func create_dynamic_env_tile(tile_id: int, pos: Vector2, parent):
	var tile = _dynamic_environment_tiles[tile_id].instance()
	parent.add_child(tile)
	tile.initialize(pos)
	return tile
