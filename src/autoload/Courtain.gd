extends Control

onready var anim_player = $AnimationPlayer
onready var courtain = $CanvasLayer/ColorRect

const START_COLOR = Color(0,0,0,1)

func _ready() -> void:
	courtain.color = START_COLOR

func show() -> void:
	anim_player.play("show")
	yield(anim_player, "animation_finished")
	
func hide() -> void:
	anim_player.play("hide")
	yield(anim_player, "animation_finished")
