extends Control

onready var messages_container = $CanvasLayer/ColorRect/Messages
onready var anim_player = $AnimationPlayer
onready var container = $CanvasLayer/ColorRect

const MAX_MESSAGE_COUNT = 5

var messages = []
var labels = []

var is_visible = true

var first_message = true

func _ready() -> void:
	toggle_visible(false, false)
	var msg_prefab = load("res://src/gui/LogMessage.tscn")
	for i in range(MAX_MESSAGE_COUNT):
		var msg = msg_prefab.instance()
		messages.append("")
		msg.text = messages[i]
		
		msg.modulate.a = float(i) / MAX_MESSAGE_COUNT
		labels.append(msg)
		messages_container.add_child(msg)
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_console"):
		toggle_visible(not is_visible, true)

func log_msg(msg):
	if first_message:
		first_message = false
		toggle_visible(true, true)
	for i in range(1, len(messages)):
		messages[i - 1] = messages[i]
	messages[len(messages) - 1] = msg
	for i in range(len(messages)):
		labels[i].text = messages[i]

func toggle_visible(value: bool, animate: bool) -> void:
	if is_visible == value:
		return
	if animate:
		if value:
			anim_player.play("show")
		else:
			anim_player.play("hide")
	else:
		container.modulate.a = 1.0 if value else 0.0
	is_visible = value
