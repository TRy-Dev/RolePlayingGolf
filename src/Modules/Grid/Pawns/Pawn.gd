extends Node2D

class_name Pawn

onready var sprite :Sprite = $Sprite
onready var fsm :StateMachine = $StateMachine
onready var anim_player :AnimationPlayer = $AnimationPlayer
onready var collider = $PushCollider

export (int, 0, 4) var speed := 0

var grid_position: Vector2
var tile_index: int

func initialize(grid_pos: Vector2, idx: int) -> void:
	grid_position = grid_pos
	tile_index = idx
	global_position = GlobalConstants.grid_to_world(grid_pos)
	
	fsm.connect("state_changed", $StateNameDisplay, "_on_state_changed")
	fsm.initialize()

func set_position(grid_pos: Vector2) -> void:
	grid_position = grid_pos
	var target_position =  GlobalConstants.grid_to_world(grid_pos)
	$Tween.stop_all()
	$Tween.interpolate_property(self, "global_position", 
			global_position, target_position, GlobalConstants.MOVE_TIME, 
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()

func destroy() -> void:
	queue_free()

## GOLF


func update_state_machine(input: Dictionary) -> void:
#	input["pawn"] = self
	fsm.update(input)


#func get_attribute(key):
#	if not _data.has(key):
#		push_error("HEY! Pawn %s does not have attribute %s" %[name, key])
#		return null
#	return _data.get(key)


## Other is pushing into me
## What should other do when interacting with me
#func get_interaction_commands(world, other: Pawn) -> Array:
#	var interactions = GameData.get_tile_interactions(tile_index)
#
#	# Is "other" player and does he have equipment I can be combined with?
#	if other.get_class() == "Actor":
#		for item in other.get_equipment().keys():
#			var result = GameData.get_recipe_result(item, tile_index)
#			if result > -2:
#				return [
#					Commands.ReplaceCommand.new(world, result, _grid_pos),
#					Commands.UpdateEquipmentCommand.new(world, other, item, -1),
#					null
#				]
#	# Can I be combined with other?
#	var result = GameData.get_recipe_result(other.tile_index, tile_index)
#	if result > -2:
#		return [Commands.CombineCommand.new(world, result, other.get_grid_pos(), _grid_pos), null]
#
#	# Can I be picked up as equipment?
#	if interactions["type"] == "equipment":
#		var commands = []
#		commands.append(Commands.MoveCommand.new(world, other.get_grid_pos(), _grid_pos))
#		if other.get_class() == "Actor":
#			# Actor should pick me up
#			commands.append(Commands.PickupCommand.new(world, other, tile_index, _grid_pos))
#			commands.append(null)
#		return commands
#
#	# Push other to my position
#	return [Commands.MoveCommand.new(world, other.get_grid_pos(), _grid_pos),]
