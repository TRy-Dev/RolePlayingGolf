extends Node2D

onready var anim_player = $AnimationPlayer

func _ready():
	AnimationController.play(anim_player, "unburrow")
