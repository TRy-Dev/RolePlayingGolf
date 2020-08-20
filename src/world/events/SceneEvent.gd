extends WorldEvent

export(PackedScene) var scene_to_load

func _init() -> void:
	event_type = "scene"

func _on_Area2D_body_entered(body: Node) -> void:
	._on_Area2D_body_entered(body)
	if not enabled:
		return
	_disable()
	body.set_physics_process(false)
	GameData.save_state("event")
	yield(Courtain.show(), "completed")
	get_tree().change_scene_to(scene_to_load)

func get_state() -> Dictionary:
	var state = .get_state()
	state["scene_to_load"] = scene_to_load
#	state["region_rect"] = sprite.region_rect
	return state

func set_state(state) -> void:
	.set_state(state)
	scene_to_load = state["scene_to_load"]
#	call_deferred("set_sprite_region", state["region_rect"])
