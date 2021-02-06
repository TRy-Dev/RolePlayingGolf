extends CanvasLayer

onready var turn_label = $VBoxContainer/Turn
onready var stamina_label = $VBoxContainer/Stamina
onready var health_label = $VBoxContainer/Health
onready var hit_force_bar = $VBoxContainer/HitForceBar

func initialize(player: Player, world: World) -> void:
	player.connect("stamina_changed", self, "_on_player_stamina_changed")
	player.connect("health_changed", self, "_on_player_health_changed")
	player.connect("hit_strength_changed", self, "_on_player_hit_force_changed")
	GlobalState.connect("turn_changed", self, "_on_turn_changed")
	
	_on_player_stamina_changed(player.stamina)
	_on_player_health_changed(player.health)
	_on_turn_changed(GlobalState.turn)

func set_hit_bar_visible(value: bool) -> void:
	hit_force_bar.visible = value

func _on_player_health_changed(health) -> void:
	health_label.text = "Health: %s" %health

func _on_player_stamina_changed(stamina) -> void:
	stamina_label.text = "Stamina: %s" %stamina

func _on_turn_changed(turn) -> void:
	turn_label.text = "Turn: %s" %turn

func _on_player_hit_force_changed(value: float) -> void:
	hit_force_bar.value = value
