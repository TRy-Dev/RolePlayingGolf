extends Node


func get_pawn_data(pawn_id: int):
	return Database.pawns.get_index(pawn_id)
