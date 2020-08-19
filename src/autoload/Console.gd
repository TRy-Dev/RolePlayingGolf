extends Control

onready var messages_container = $CanvasLayer/Messages

const MAX_MESSAGE_COUNT = 10

var messages = []
var labels = []

func _ready() -> void:
	var msg_prefab = load("res://src/LogMessage.tscn")
	for i in range(MAX_MESSAGE_COUNT):
		var msg = msg_prefab.instance()
		messages.append("")
		msg.text = messages[i]
		
		msg.modulate.a = float(i) / MAX_MESSAGE_COUNT
		labels.append(msg)
		messages_container.add_child(msg)

func log_msg(msg):
	for i in range(1, len(messages)):
		messages[i - 1] = messages[i]
	messages[len(messages) - 1] = msg
	for i in range(len(messages)):
		labels[i].text = messages[i]

#func get_log_state():
#	return messages
#
#func set_log_state(value):
#	messages = value
#	for i in range(len(messages)):
#		labels[i].text = messages[i]
