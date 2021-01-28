extends PawnState


func enter(previous: State) -> void:
	pawn.unburrow()

func update(input: Dictionary) -> void:
	emit_signal("finished", "Burrowed")
