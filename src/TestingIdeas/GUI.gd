extends CanvasLayer

onready var turn_label = $VBoxContainer/Turn
onready var stamina_label = $VBoxContainer/Stamina
onready var health_label = $VBoxContainer/Health
onready var hit_force_bar = $VBoxContainer/HitForceBar

onready var talk_to_ui = $WorldGUI/TalkUI

func initialize(player: Player, world: World) -> void:
	player.connect("stamina_changed", self, "_on_player_stamina_changed")
	player.connect("health_changed", self, "_on_player_health_changed")
	player.connect("hit_strength_changed", self, "_on_player_hit_force_changed")
	player.interaction_controller.connect("interaction_entered", self, "_on_interaction_entered")
	player.interaction_controller.connect("interaction_exited", self, "_on_interaction_exited")
	GlobalState.connect("turn_changed", self, "_on_turn_changed")

	_on_player_stamina_changed(player.stamina)
	_on_player_health_changed(player.health)
	_on_turn_changed(GlobalState.turn)
	_on_player_stopped_charging_shot()
	_on_interaction_exited(null)

func _on_player_health_changed(health) -> void:
	health_label.text = "Health: %s" %health

func _on_player_stamina_changed(stamina) -> void:
	stamina_label.text = "Stamina: %s" %stamina

func _on_turn_changed(turn) -> void:
	turn_label.text = "Turn: %s" %turn

func _on_player_hit_force_changed(value: float) -> void:
	hit_force_bar.value = value

func _on_interaction_entered(interaction: Interaction) -> void:
	var pos = interaction.get_interaction_owner().global_position
	pos += Vector2(0.0, 8.0)
	talk_to_ui.rect_position = pos
	talk_to_ui.visible = true

func _on_interaction_exited(interaction: Interaction) -> void:
	talk_to_ui.visible = false

func _on_player_started_charging_shot() -> void:
	hit_force_bar.visible = true

func _on_player_stopped_charging_shot() -> void:
	hit_force_bar.visible = false
