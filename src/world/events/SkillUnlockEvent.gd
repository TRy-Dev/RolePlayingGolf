extends WorldEvent

export(String) var skill_name

func _init() -> void:
	event_type = "unlock-skill"

func _on_Area2D_body_entered(body: Node) -> void:
	if not enabled:
		return
	GameData.unlock_skill(skill_name)
	_disable()
	._on_Area2D_body_entered(body)

func get_state() -> Dictionary:
	var state = .get_state()
	state["skill_name"] = skill_name
	return state

func set_state(state) -> void:
	.set_state(state)
	skill_name = state["skill_name"]
