extends State

func enter(previous: State) -> void:
#	Courtain.play("show_dim")
	owner.set_pause_game(true)
	
func exit(next: State) -> void:
#	Courtain.play("hide_dim")
	owner.set_pause_game(false)

func update(input: Dictionary) -> void:
	if input["controls"]["pause"]:
		emit_signal("finished", "pop")
