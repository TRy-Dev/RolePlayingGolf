extends Control

onready var anim_player :AnimationPlayer = $AnimationPlayer
onready var courtain = $CanvasLayer/ColorRect

var START_COLOR = Colors.get_color("black")

var anim_length = 1.0

func _ready() -> void:
	courtain.color = START_COLOR
	anim_player.playback_speed = anim_player.get_animation("show").length / anim_length

func show() -> void:
	anim_player.play("show")
	yield(anim_player, "animation_finished")
	
func hide() -> void:
	anim_player.play("hide")
	yield(anim_player, "animation_finished")
