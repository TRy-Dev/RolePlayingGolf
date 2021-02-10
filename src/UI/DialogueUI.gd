extends Control

signal option_selected(index)

onready var anim_player = $AnimationPlayer
onready var text = $Background/Container/Text
onready var container = $Background/Container
onready var panel = $Background
onready var text_tween = $TextTween

var buttons = []

var current_btn_idx = -1

const CHARS_PER_SECOND = 45.0

func _ready():
	AnimationController.reset(anim_player)

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
	text_tween.stop_all()
	text_tween.interpolate_property(text, "percent_visible", 0.0, 1.0, len(text.text) / CHARS_PER_SECOND, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	text_tween.start()
	current_btn_idx = 0
	buttons[current_btn_idx].grab_focus()

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

func _on_dialogue_started():
	AnimationController.play(anim_player, "show")
#	anim_player.play("show")

func _on_dialogue_finished():
	AnimationController.play(anim_player, "hide", false)
#	anim_player.play("hide")

func _on_Background_sort_children():
	panel.rect_size.y = 0.0
	panel.margin_left = 0.0
	panel.margin_right = 0.0
	panel.margin_top = 0.0
	panel.margin_bottom = -20.0
