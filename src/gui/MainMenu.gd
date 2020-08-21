extends Control

export(PackedScene) var scene_to_load
onready var control_anim_player = $CanvasLayer/VBoxContainer/PressSpace/AnimationPlayer
onready var control_timer = $ControlEnabledTimer
onready var control_parent = $CanvasLayer/VBoxContainer/PressSpace
onready var main_anim_player = $AnimationPlayer

var scene_is_loading = false

func _ready() -> void:
	control_parent.modulate.a = 0
	MusicPlayer.play_song("main-menu")
	Courtain.hide()
	Console.toggle_visible(false, false)
	
	main_anim_player.play("show")
	yield(main_anim_player, "animation_finished")
	control_timer.start()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action") and not scene_is_loading \
			and control_timer.is_stopped():
		SoundEffects.play_audio("ui-click")
		_load_scene()


func _load_scene() -> void:
	print("started loading scene")
	scene_is_loading = true
	yield(Courtain.show(), "completed")
	get_tree().change_scene_to(scene_to_load)


func _on_ControlEnabledTimer_timeout() -> void:
	control_anim_player.play("show")
