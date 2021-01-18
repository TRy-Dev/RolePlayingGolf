extends Node

const TILE_SIZE = 16
const MOVE_TIME = 0.20

var _pawns := []
var _recipes := {}

func _init() -> void:
	_load_pawns_data()
	_load_recipe_data()

func _load_pawns_data() -> void:
	_pawns = _load_json("res://assets/pawns.json")["pawns"]
	for i in range(len(_pawns)):
		assert(_pawns[i]["id"] == i)

func _load_recipe_data():
	var recipe_array = _load_json("res://assets/recipes.json")["recipes"]
	for r in recipe_array:
		_recipes[_sorted(r["ingredient_1"], r["ingredient_2"])] = r["result"]
	
func _load_json(file_path):
	var file = File.new()
	file.open(file_path, file.READ)
	var json = file.get_as_text()
	file.close()
	return JSON.parse(json).result

func _sorted(num_1: int, num_2: int) -> Array:
	if num_2 < num_1:
		return [num_2, num_1]
	return [num_1, num_2]

func get_pawn_texture_by_id(id: int):
	var tex_name = _pawns[id]["sprite"]
	var tex = load("res://assets/alpha/%s" % tex_name)
	if not tex:
		print("Could not find sprite %s. Falling back to empty texture" % tex_name)
		tex = load("res://assets/empty_16x16.png")
	return tex
#
func get_pawn_instance_by_id(id: int, pos: Vector2, parent):
	var pawn_data = _pawns[id].duplicate(true)
	var pawn
	if pawn_data["type"] == "actor":
		pawn = load("res://src/Modules/Grid/Actor.tscn").instance()
	else:
		pawn = load("res://src/Modules/Grid/Pawn.tscn").instance()
	parent.add_child(pawn)
#	pawn.call_deferred("init", pos, pawn_data)
	pawn.init(pos, pawn_data)
	return pawn

func get_tile_interactions(id: int):
	var default = _pawns[id].get("default_interaction")
	return {
		"type": _pawns[id]["type"],
		"default": default if default else "push"
	}

func get_recipe_result(id_1: int, id_2: int) -> int:
	var ingredients_sorted = _sorted(id_1, id_2)
	if _recipes.has(ingredients_sorted):
		return _recipes[ingredients_sorted]
	return -2

#func debug_commands(commands: Array) -> void:
#	var out = []
#	for c in commands:
#		out.append(c.get_class())
#	print(out)
	
