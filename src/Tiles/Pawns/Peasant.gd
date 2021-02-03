extends Pawn

#func _ready():
#	$Label.visible = false

func on_player_entered(player: Player) -> void:
#	$Label.visible = true
#	yield(get_tree().create_timer(2.0), "timeout")
#	$Label.visible = false
	pass

func on_player_exited(player: Player) -> void:
	pass
