extends Node

class Command:
	var _world
	
	func _init(world) -> void:
		_world = world
		
	func execute() -> void:
		pass
		
	func undo() -> void:
		pass
		
	func get_class() -> String:
		return "Command"

class MoveCommand extends Command:
	var _pos_from
	var _pos_to
	
	func _init(world, pos_from, pos_to).(world):
		_pos_from = pos_from
		_pos_to = pos_to

	func execute() -> void:
		_world.move_pawn(_pos_from, _pos_to)

	func undo() -> void:
		_world.move_pawn(_pos_to, _pos_from)
	
	func get_class() -> String:
		return "Move"


class CombineCommand extends Command:
	var _pos_from
	var _pos_to
	var _pawn_id_at_pos_from
	var _pawn_id_at_pos_to
	var _created_id

	func _init(world, created_id :int, pos_from :Vector2, pos_to :Vector2).(world):
		_pos_from = pos_from
		_pos_to = pos_to
		_pawn_id_at_pos_from = world.get_pawn_id_at(pos_from)
		_pawn_id_at_pos_to = world.get_pawn_id_at(pos_to)
		_created_id = created_id
		
	func execute() -> void:
		# Tilemap only behaviour
#		_world.destroy_pawn(_pos_from)
#		_world.destroy_pawn(_pos_to)
#		_world.create_pawn(_created_id, _pos_to)
		
		# With animation
		_world.destroy_pawn(_pos_to)
		_world.move_pawn(_pos_from, _pos_to)
		_world.destroy_pawn(_pos_to)
		_world.create_pawn(_created_id, _pos_to)

	func undo() -> void:
		# Tilemap only behaviour
#		_world.destroy_pawn(_pos_to)
#		_world.create_pawn(_pawn_id_at_pos_from, _pos_from)
#		_world.create_pawn(_pawn_id_at_pos_to, _pos_to)

		# With animation
		_world.destroy_pawn(_pos_to)
		_world.create_pawn(_pawn_id_at_pos_from, _pos_to)
		_world.move_pawn(_pos_to, _pos_from)
		_world.create_pawn(_pawn_id_at_pos_to, _pos_to)
	
	func get_class() -> String:
		return "Combine"


class PickupCommand extends Command:
	var _item_id
	var _pos
	var _actor
	
	func _init(world, actor, item_id : int, pos: Vector2).(world):
		_actor = actor
		_item_id = item_id
		_pos = pos
		
	func execute() -> void:
		_world.destroy_pawn(_pos)
		_actor.add_item(_item_id)
		
	func undo() -> void:
		_world.create_pawn(_item_id, _pos)
		_actor.remove_item(_item_id)

	func get_class() -> String:
		return "Pickup"


class ReplaceCommand extends Command:
	var _new_item_id
	var _old_item_id
	var _pos
	
	func _init(world, new_item_id: int, pos: Vector2).(world):
		_new_item_id = new_item_id
		_old_item_id = world.get_pawn_id_at(pos)
		_pos = pos

	func execute() -> void:
		_world.replace_pawn(_new_item_id, _pos)
		
	func undo() -> void:
		_world.replace_pawn(_old_item_id, _pos)

	func get_class() -> String:
		return "Replace"


class UpdateEquipmentCommand extends Command:
	var _actor
	var _item_id
	var _amount
	
	func _init(world, actor, item_id: int, amount: int).(world):
		_actor = actor
		_item_id = item_id
		_amount = amount

	func execute() -> void:
		if _amount > 0:
			_actor.add_item(_item_id)
		else:
			_actor.remove_item(_item_id)
		
	func undo() -> void:
		if _amount > 0:
			_actor.remove_item(_item_id)
		else:
			_actor.add_item(_item_id)

	func get_class() -> String:
		return "UpdateEquipment"
