extends Control

signal option_selected(index)

onready var text = $Background/Container/Text
onready var container = $Background/Container

var buttons = []

var current_btn_idx = -1

func set_dialogue(dialogue: Dictionary) -> void:
	_update_ui(dialogue)

func _update_ui(data: Dictionary) -> void:
	for b in buttons:
		b.queue_free()
	buttons = []
	text.text = ""
	for line in data["lines"]:
		text.text += line
	for i in range(len(data["options"])):
		var opt = data["options"][i]
		_add_button(opt.text, i)
	_add_button("END", -1)
	current_btn_idx = 0
	buttons[current_btn_idx].grab_focus()
#	if not len(data["options"]):
#		text.text += "\n Dialogue has ended!"
#
func _option_selected(idx) -> void:
	buttons[current_btn_idx].release_focus()
	emit_signal("option_selected", idx)

func _add_button(text: String, idx: int) -> void:
	var btn = Button.new()
	btn.text = text
	btn.connect("pressed", self, "_option_selected", [idx])
	container.add_child(btn)
	buttons.append(btn)

func change_option(delta: int):
	current_btn_idx = current_btn_idx + delta
	if current_btn_idx < 0:
		current_btn_idx = len(buttons) - 1
	elif current_btn_idx >= len(buttons):
		current_btn_idx = 0
	buttons[current_btn_idx].grab_focus()
