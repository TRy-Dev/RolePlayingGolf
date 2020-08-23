extends Control

onready var anim_player :AnimationPlayer = $AnimationPlayer
onready var courtain = $CanvasLayer/ColorRect

var START_COLOR = Colors.get_color("black")

var anim_length = 2.0

onready var _effects = {
	"danger": $CanvasLayer/Danger/AnimationPlayer,
	"dim": $CanvasLayer/Dim/AnimationPlayer,
	"perfect-battle": $CanvasLayer/PerfBattle/AnimationPlayer,
}


func _ready() -> void:
	courtain.color = START_COLOR
	anim_player.playback_speed = anim_player.get_animation("show").length / anim_length

func show() -> void:
	anim_player.play("show")
	yield(anim_player, "animation_finished")
	
func hide() -> void:
	anim_player.play("hide")
	yield(anim_player, "animation_finished")


func play_effect(eff_name):
	if not eff_name in _effects:
		return
	_effects[eff_name].play("anim")


func stop_effects(): 
	print("Stop all courtain effects")
	pass


onready var skill_unlock_anim = $CanvasLayer/SkillUnlock/AnimationPlayer
onready var title = $CanvasLayer/SkillUnlock/Text/Title
onready var description = $CanvasLayer/SkillUnlock/Text/Desc
onready var bg = $CanvasLayer/SkillUnlock/Bg

func play_skill_unlock(skill):
	title.text = skill["ui-name"]
	description.text = skill["description"]
	if randf() < 0.5:
		bg.color = Colors.get_color("yellow")
	else:
		bg.color = Colors.get_color("blue")
	skill_unlock_anim.play("unlock")
	






