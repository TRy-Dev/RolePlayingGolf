extends Area2D

var interaction :Interaction = null

func interact() -> Interaction:
	if interaction:
		interaction.start()
	return interaction

func _on_area_entered(area):
	print("Entered interaction area %s" %area.name)
	if interaction:
		print("HEY! Overriding interaction %s with %s" %[interaction.name, area.name])
	interaction = area

func _on_area_exited(area):
	print("Exited interaction area %s" %area.name)
	interaction = null
