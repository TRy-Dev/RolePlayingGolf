extends Pawn

# Enemies, Events, Hearts - assigns to apropieate parent
export(String) var spawn_group

export(PackedScene) var pawn_to_spawn
export(int, 1, 3) var spawn_count = 1

var rng = RandomNumberGenerator.new()


func _ready() -> void:
	if spawn_group != "" and not spawn_group in ["Events", "Enemies", "Hearts"]:
		pawn_to_spawn = null
		assert(false, "---- !!! unknown spawn type: %s. Not able to spawn" % spawn_group)
	rng.randomize()
	._ready()

func move():
	var dir = _get_valid_dir(_random_dir())
	if dir == Vector2():
		yield(get_tree(), "idle_frame")
		return
	if move_dist > 0:
		_find_target_if_null()
		for i in range(spawn_count):
			_spawn_pawn(global_position + dir * GameData.TILE_SIZE)
		yield(.move(), "completed")
	else:
		for i in range(spawn_count - 1):
			_spawn_pawn(global_position + dir * GameData.TILE_SIZE)
		yield(_spawn_pawn(global_position + dir * GameData.TILE_SIZE), "completed")
	
func _random_dir() -> Vector2:
	var num = rng.randf()
	if num < 0.25:
		return Vector2(1, 0)
	elif num < 0.5:
		return Vector2(-1, 0)
	elif num < 0.75:
		return Vector2(0, 1)
	else:
		return Vector2(0, -1)

func _spawn_pawn(pos: Vector2):
	if not pawn_to_spawn:
		yield(get_tree(), "idle_frame")
		return
	SoundEffects.play_audio("summon")
	var spawned = pawn_to_spawn.instance()
	spawned.global_position = pos
	var parent = owner.get_node(spawn_group)
	parent.add_child(spawned)
	spawned.set_owner(owner)
	print("Spawned pawn %s" % spawned.name)
	yield(get_tree(), "idle_frame")

func find_target() -> bool:
	target = "ABC"
	return true

func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player":
		_destroy()

func _on_target_destroyed(t) -> void:
	target = owner.get_closest_heart(global_position, t)

func _find_target_if_null():
	if not target or not is_instance_valid(target):
		target = owner.get_closest_heart(global_position, target)
