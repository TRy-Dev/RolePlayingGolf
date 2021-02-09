extends GameState

var interaction = null

func enter(previous: State) -> void:
	interaction = player.get_interaction()# owner.get_current_interaction()
	if not interaction:
		push_error("HEY! Started interaction state, but no interaction found!")
		return
	camera.set_target(interaction.get_interaction_target())
	camera.set_zoom_level("close")
	Courtain.play("show_bars")
	interaction.connect("finished", self, "_on_interaction_finished")
	interaction.start()

func exit(next: State) -> void:
	camera.set_target(camera_target)
	camera.set_zoom_level("medium")
	Courtain.play("show_bars", false, -1)
	interaction.disconnect("finished", self, "_on_interaction_finished")

func _on_interaction_finished():
	emit_signal("finished", "WaitingForPlayerInput")
