extends Node

# Array of pawns -> prefab scene
var _prefabs_map = {
	0: preload("res://src/Pawns/Peasant.tscn"),
	1: preload("res://src/TestingIdeas/MoleHunt/Mole.tscn"),
}

#var pawn_prefab = preload("res://src/Modules/Grid/Pawns/Pawn.tscn")

func create_pawn(pawn_id: int, pos: Vector2, parent) -> Pawn:
	var pawn = _prefabs_map[pawn_id].instance()
	parent.add_child(pawn)
	pawn.initialize(pos, pawn_id)
	return pawn

#func _init():
#	_initialize_pawns()
#
#func _initialize_pawns() -> void:
#	for i in range(Database.pawns.all.size()):
#		var pawn_data = Database.pawns.get_index(i)
#		_prefabs_map[i] = load(pawn_data.template)
#
#func create_pawn(pawn_id: int, pos: Vector2, parent) -> Pawn:
#	var pawn = _prefabs_map[pawn_id].instance()
#	var pawn_data = Database.pawns.get_index(pawn_id)
#	parent.add_child(pawn)
#	pawn.initialize(pos, pawn_id, pawn_data)
#	return pawn

#func get_pawn_data(pawn_id: int):
#	return Database.pawns.get_index(pawn_id)
