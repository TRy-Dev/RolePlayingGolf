extends Interaction

onready var dialogue_ui = $DialogueUI

# Move animations to DialogueUI
#onready var anim_player = $AnimationPlayer

var active = false

func _ready():
	dialogue_ui.connect("option_selected", self, "_on_dialogue_option_selected")
	connect("started", dialogue_ui, "_on_dialogue_started")
	connect("finished", dialogue_ui, "_on_dialogue_finished")

func start() -> void:
	var npc_name = owner.get_name()
	var dialogue = DialogueController.start_dialogue(npc_name)
	if not dialogue["lines"] and not dialogue["options"]:
		print("Empty dialogue returned for npc %s" %npc_name)
#		AnimationController.play(anim_player, "hide")
		emit_signal("finished")
		return
	dialogue_ui.set_dialogue(dialogue)
	active = true
#	AnimationController.play(anim_player, "show")
	emit_signal("started")

func _on_dialogue_option_selected(idx) -> void:
	if idx < 0:
		active = false
#		AnimationController.play(anim_player, "hide")
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
