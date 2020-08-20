extends Control

onready var heart = $Background/Battle/Rules/Heart
onready var peasant = $Background/Battle/Rules/Peasant
onready var anim_player = $AnimationPlayer

func _ready() -> void:
#	heart.get_node("PawnUI").set_color(Colors.get_color("yellow"))
#	peasant.get_node("PawnUI").set_color(Colors.get_color("red"))
	if GameData.tutorial_visible:
		modulate.a = 1
	else:
		modulate.a = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("hide_tutorial"):
		GameData.tutorial_visible = not GameData.tutorial_visible
		if GameData.tutorial_visible:
			anim_player.play("show")
		else:
			anim_player.play("hide")
