extends Control

onready var anim_player :AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	for effect in $CanvasLayer.get_children():
		effect.color.a = 0.0

func play(name) -> void:
	AnimationController.play(anim_player, name)
