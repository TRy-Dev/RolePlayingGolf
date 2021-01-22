extends Node2D

class_name Pawn

onready var sprite :Sprite = $Sprite
#onready var anim_player :AnimationPlayer = $AnimationPlayer

var tile_index: int # setget set_tile_index
var grid_position: Vector2 #setget ,get_grid_pos 
#var _data = {}

#func get_class(): 
#	return "Pawn"

enum PawnDebugStates {
	MOVING, IDLE, STUCK
}
var debug_state = PawnDebugStates.IDLE


func init(grid_pos: Vector2, data: Dictionary) -> void:
	grid_position = grid_pos
	global_position = (grid_pos + 0.5 * Vector2.ONE) * GlobalConstants.TILE_SIZE
	tile_index = data["id"]
	sprite.texture = GameData.get_pawn_texture_by_id(tile_index)
	
	$Outline.texture = sprite.texture
	set_selected(false)


func set_position(grid_pos: Vector2) -> void:
	grid_position = grid_pos
	var target_position = (grid_pos + 0.5 * Vector2.ONE) * GlobalConstants.TILE_SIZE
	$Tween.stop_all()
	$Tween.interpolate_property(self, "global_position", 
			global_position, target_position, GlobalConstants.MOVE_TIME, 
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()

func destroy() -> void:
	queue_free()

## GOLF

func set_selected(value: bool) -> void:
	$Outline.visible = value

func get_desired_position() -> Vector2:
	# for now returning random neighboring direction
	return grid_position + Rng.rand_array_element(Math.CARDINAL_DIRECTIONS)


func set_debug_state(state: int) -> void:
	debug_state = state
	update()
#	sprite.modulate = color_map[state]

func _draw():
	var color_map = {
		PawnDebugStates.MOVING: Color.green,
		PawnDebugStates.IDLE: Color.yellow,
		PawnDebugStates.STUCK: Color.red
	}
	draw_circle(Vector2(4, -4), 1, color_map[debug_state])

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
