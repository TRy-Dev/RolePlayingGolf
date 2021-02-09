extends Area2D

signal interaction_entered(interaction)
signal interaction_exited(interaction)

var interaction :Interaction = null

func get_interaction() -> Interaction:
	return interaction

func _on_area_entered(area):
	if interaction:
		print("HEY! Overriding interaction %s with %s" %[interaction.name, area.name])
	interaction = area
	emit_signal("interaction_entered", interaction)

func _on_area_exited(area):
	emit_signal("interaction_exited", interaction)
	interaction = null
