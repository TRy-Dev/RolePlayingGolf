extends TileMap

onready var anim_player = $AnimationPlayer
onready var pos_change_cd = $PosChangeCooldown

var _positions = []
var current_position

#func _ready() -> void:
#	anim_player.play("pulse")
#	_positions = get_used_cells()
#	for i in range(len(_positions)):
#		_positions[i] = map_to_world(_positions[i]) + 0.5 * cell_size
#	current_position = _positions[0]
#
#func update_current_position(dir):
#	if not pos_change_cd.is_stopped():
#		return
#	var start_pos = current_position
#	var closer_position = start_pos
#	for p in _positions:
#		if p == start_pos:
#			continue
#		var dist_sq = (start_pos + dir - p).length_squared()
#		if dist_sq < (start_pos - p).length_squared():
#				if (start_pos != closer_position):
#					if dist_sq <= (start_pos - closer_position).length_squared():
#						closer_position = p
#				else:
#					closer_position = p
#	if current_position != closer_position:
#		SoundEffects.play_audio("click")
#		pos_change_cd.start()
#		current_position = closer_position
#
#func hide():
#	visible = false
#
#func show():
#	visible = true
