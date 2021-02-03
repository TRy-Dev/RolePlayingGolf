extends Interaction

onready var anim_player = $AnimationPlayer
onready var label = $Background/Label

var dialogue_text = ["Hello.\nThis text is too long"]

const CHARS_PER_SECOND := 8.0

func _ready():
	AnimationController.reset(anim_player)
	label.text = dialogue_text[0]

func start() -> void:
	anim_player.playback_speed = CHARS_PER_SECOND / len(label.text)
	AnimationController.play(anim_player, "show_text")
	emit_signal("started")
