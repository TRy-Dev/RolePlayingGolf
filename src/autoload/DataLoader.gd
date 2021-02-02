extends Node

# Array of pawns -> prefab scene
var _pawns = {
	0: preload("res://src/Pawns/Peasant.tscn"),
	1: preload("res://src/TestingIdeas/RatHunt/DirtRat.tscn"),
}

var _tiles = {
	0: preload("res://src/TestingIdeas/RatHunt/Hole.tscn"),
}

func create_pawn(idx: int, pos: Vector2, parent) -> Pawn:
	var pawn = _pawns[idx].instance()
	parent.add_child(pawn)
	pawn.initialize(pos, idx)
	return pawn

func create_tile(idx: int, pos: Vector2, parent):
	var tile = _tiles[idx].instance()
	parent.add_child(tile)
	tile.initialize(pos, idx)
	return tile
