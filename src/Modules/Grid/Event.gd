extends Node2D

var _toggles = {}

func init(world, tilemap: TileMap) -> void:
	var toggles = $Toggles.get_children()
	var changers = $Changers.get_children()
	
	for t in toggles:
		var grid_pos = tilemap.world_to_map(t.global_position)
		_toggles[grid_pos] = t
	
	for c in changers:
		c.init(world, toggles)
	
	world.connect("pawn_entered", self, "_pawn_entered")
	world.connect("pawn_exited", self, "_pawn_exited")
	

func _pawn_entered(pos, idx) -> void:
	var toggle = _toggles.get(pos)
	if toggle:
		toggle.pawn_entered(idx)
	
func _pawn_exited(pos, idx) -> void:
	var toggle = _toggles.get(pos)
	if toggle:
		toggle.pawn_exited(idx)
