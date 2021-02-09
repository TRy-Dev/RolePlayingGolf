extends Interaction

onready var dialogue_ui = $DialogueUI

var dialogue_path = ""

func _ready():
	dialogue_ui.connect("option_selected", self, "_on_dialogue_option_selected")
	connect("started", dialogue_ui, "_on_dialogue_started")
	connect("finished", dialogue_ui, "_on_dialogue_finished")

func start() -> void:
	if not dialogue_path:
		print("HEY! No dialogue path set for %s" %get_parent().name)
		return
	var dialogue = DialogueController.start_dialogue(dialogue_path)
	if not dialogue["lines"] and not dialogue["options"]:
		print("Empty dialogue returned for npc %s" %get_parent().name)
	dialogue_ui.set_dialogue(dialogue)
	.start()

func _on_dialogue_option_selected(idx) -> void:
	if idx < 0:
		finish()
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
