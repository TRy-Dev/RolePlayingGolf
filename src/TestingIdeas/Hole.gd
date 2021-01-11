extends Area2D

signal player_entered(s)

onready var timer = $Timer

func _on_Timer_timeout():
	AudioController.sfx.play("goal")
	emit_signal("player_entered", self)

func _on_body_entered(body):
	timer.start()

func _on_body_exited(body):
	timer.stop()
