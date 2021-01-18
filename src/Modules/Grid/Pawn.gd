extends Node2D

class_name Pawn

onready var sprite :Sprite = $Sprite
#onready var anim_player :AnimationPlayer = $AnimationPlayer

var tile_index: int setget set_tile_index
var _grid_pos: Vector2 setget ,get_grid_pos 
var _data = {}

func get_class(): 
	return "Pawn"

func init(grid_pos: Vector2, data: Dictionary) -> void:
	set_tile_index(data["id"])
	position = (grid_pos + 0.5 * Vector2.ONE) * GlobalConstants.TILE_SIZE
	_grid_pos = grid_pos
	_data = data
	
#	sprite.modulate.a = 0.0
#	anim_player.play("appear")

func set_pos(grid_pos: Vector2) -> void:
	_grid_pos = grid_pos
	var target_position = (grid_pos + 0.5 * Vector2.ONE) * GlobalConstants.TILE_SIZE
	$Tween.interpolate_property(self, "position", 
			position, target_position, GlobalConstants.MOVE_TIME, 
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func get_grid_pos() -> Vector2:
	return _grid_pos

func set_tile_index(value: int) -> void:
	tile_index = value
	sprite.texture = GameData.get_pawn_texture_by_id(tile_index)

func destroy() -> void:
#	anim_player.play("hide")
#	yield(anim_player, "animation_finished")
	queue_free()


func get_attribute(key):
	if not _data.has(key):
		push_error("HEY! Pawn %s does not have attribute %s" %[name, key])
	return _data.get(key)

# Other is pushing into me
# What should other do when interacting with me
func get_interaction_commands(world, other: Pawn) -> Array:
	var interactions = GameData.get_tile_interactions(tile_index)
	
	# Is "other" player and does he have equipment I can be combined with?
	if other.get_class() == "Actor":
		for item in other.get_equipment().keys():
			var result = GameData.get_recipe_result(item, tile_index)
			if result > -2:
				return [
					Commands.ReplaceCommand.new(world, result, _grid_pos),
					Commands.UpdateEquipmentCommand.new(world, other, item, -1),
					null
				]
	# Can I be combined with other?
	var result = GameData.get_recipe_result(other.tile_index, tile_index)
	if result > -2:
		return [Commands.CombineCommand.new(world, result, other.get_grid_pos(), _grid_pos), null]
	
	# Can I be picked up as equipment?
	if interactions["type"] == "equipment":
		var commands = []
		commands.append(Commands.MoveCommand.new(world, other.get_grid_pos(), _grid_pos))
		if other.get_class() == "Actor":
			# Actor should pick me up
			commands.append(Commands.PickupCommand.new(world, other, tile_index, _grid_pos))
			commands.append(null)
		return commands
	
	# Push other to my position
	return [Commands.MoveCommand.new(world, other.get_grid_pos(), _grid_pos),]
