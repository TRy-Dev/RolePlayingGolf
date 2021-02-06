extends GameState

var interaction = null

func enter(previous: State) -> void:
	interaction = owner.get_current_interaction()
	if not interaction:
		push_error("Sth went wrong. Order perhaps?")
	interaction.connect("finished", self, "_on_interaction_finished")
	interaction.start()

func exit(next: State) -> void:
	interaction.disconnect("finished", self, "_on_interaction_finished")

#func update(input: Dictionary) -> void:
#	# if interaction completed
##	if input["controls"]["interact"]:
##		emit_signal("finished", "WaitingForPlayerInput")
##		return
#	.update(input)

func _on_interaction_finished():
	emit_signal("finished", "WaitingForPlayerInput")
