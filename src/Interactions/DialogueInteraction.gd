extends Interaction

onready var dialogue_ui = $DialogueUI

var active = false

func _ready():
	dialogue_ui.set_visible(false)
	dialogue_ui.connect("option_selected", self, "_on_dialogue_option_selected")

func start() -> void:
	var npc_name = owner.get_name()
	var dialogue = DialogueController.start_dialogue(npc_name)
	dialogue_ui.set_dialogue(dialogue)
	active = true
	dialogue_ui.set_visible(true)
	emit_signal("started")

func _on_dialogue_option_selected(idx) -> void:
	if idx < 0:
		active = false
		dialogue_ui.set_visible(false)
		emit_signal("finished")
		return
	var dialogue = DialogueController.select_option(idx)
	dialogue_ui.set_dialogue(dialogue)

func _process(delta):
	if not active:
		return
	if Input.is_action_just_pressed("ui_down"):
		dialogue_ui.change_option(1)
	if Input.is_action_just_pressed("ui_up"):
		dialogue_ui.change_option(-1)
