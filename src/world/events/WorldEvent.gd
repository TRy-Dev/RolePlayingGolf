extends Node2D

# has to be explicitly called in inheriting node, otherwise silent
signal world_event_reached

class_name WorldEvent

export(String) var start_sound = ""
export(String) var color = "white"
export(Texture) var sprite_texture

onready var sprite = $Sprite
onready var collider = $Area2D/CollisionShape2D
onready var tween :Tween = $Tween
onready var anim_player = $AnimationPlayer

var enabled := true
var event_type := ""

const COLOR_CHANGE_TIME = 0.4

func _ready() -> void:
	_apply_state()

func _on_Area2D_body_entered(body: Node) -> void:
	if start_sound:
		SoundEffects.play_audio(start_sound)

func get_state() -> Dictionary:
	return {
		"position": global_position,
		"type": event_type,
		"enabled": enabled,
		"start-sound": start_sound,
		"color": color,
		"sprite_texture": sprite_texture
	}
	
func set_state(state) -> void:
	if not state["enabled"]:
		_disable()
		return
	global_position = state["position"]
	event_type = state["type"]
	start_sound = state["start-sound"]
	color = state["color"]
	sprite_texture = state["sprite_texture"]
	call_deferred("_apply_state")
	
func _disable() -> void:
	if anim_player:
		anim_player.play("hide")
	enabled = false
	if collider:
		collider.call_deferred("disabled", true)
	if anim_player:
		yield(anim_player, "animation_finished")
	call_deferred("hide")

func set_sprite_region(region) -> void:
	sprite.region_rect = region

func hide() -> void:
	sprite.visible = false

func set_color(col):
	tween.stop_all()
	tween.interpolate_property(sprite, "modulate", sprite.modulate, Colors.get_color(col), COLOR_CHANGE_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()

func _apply_state():
	sprite.modulate =  Colors.get_color(color)
	sprite.texture = sprite_texture


func _on_Area2D_area_entered(area: Area2D) -> void:
	print("AT ME!! %s --- AREA ENTERED %s" % [name, area.owner.name])
	SoundEffects.play_audio("enemy-hurt")
	_disable()
