extends Node


func _init():
	pass
	# load data 
	
func get_pawn_data(pawn_id):
	return Database.pawns.get_index(pawn_id)
