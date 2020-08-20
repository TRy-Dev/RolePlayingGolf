extends Node2D

class_name WorldEvent

export(String) var start_sound = ""

onready var sprite = $Sprite
onready var collider = $Area2D/CollisionShape2D

var enabled := true
var event_type := ""

func _on_Area2D_body_entered(body: Node) -> void:
	if start_sound:
		SoundEffects.play_audio(start_sound)
	print("player entered event")

func get_state() -> Dictionary:
	return {
		"position": global_position,
		"type": event_type,
		"enabled": enabled
	}
	
func set_state(state) -> void:
	if not state["enabled"]:
		_disable()
		return
	global_position = state["position"]
	event_type = state["type"]
	
	
func _disable() -> void:
	enabled = false
	call_deferred("hide")

func set_sprite_region(region) -> void:
	sprite.region_rect = region

func hide() -> void:
	collider.disabled = true
	sprite.visible = false
