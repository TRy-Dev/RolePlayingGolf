extends Pawn

signal equipment_changed

class_name Actor

# id -> amount
var items = {}

var strength = 1

func init(grid_pos: Vector2, data: Dictionary) -> void:
	set_equipment({})
	.init(grid_pos, data)

func set_pos(grid_pos: Vector2) -> void:
#	SoundEffects.play_audio("step")
	.set_pos(grid_pos)

func get_class(): 
	return "Actor"

func add_item(item_id: int) -> void:
	if items.has(item_id):
		items[item_id] += 1
	else:
		items[item_id] = 1
	emit_signal("equipment_changed", items)

func remove_item(item_id: int) -> void:
	assert(items.has(item_id) and items[item_id] > 0)
	items[item_id] -= 1
	if items[item_id] < 1:
		items.erase(item_id)
	emit_signal("equipment_changed", items)

func get_equipment() -> Array:
	return items
	
func set_equipment(value) -> void:
	items = value
	emit_signal("equipment_changed", items)
