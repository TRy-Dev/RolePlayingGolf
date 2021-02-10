extends State

func enter(previous: State) -> void:
	owner.set_pause_game(true)
	
func exit(next: State) -> void:
	owner.set_pause_game(false)

func update(input: Dictionary) -> void:
	if input["controls"]["pause"]:
		emit_signal("finished", "pop")
