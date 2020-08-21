extends Control


onready var anim_player = $AnimationPlayer

func _ready() -> void:
	if GameData.tutorial_visible:
		modulate.a = 1
	else:
		modulate.a = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_tutorial"):
		GameData.tutorial_visible = not GameData.tutorial_visible
		if GameData.tutorial_visible:
			anim_player.play("show")
		else:
			anim_player.play("hide")
