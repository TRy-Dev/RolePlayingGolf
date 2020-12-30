extends Node2D

signal scene_ready
signal turn_step_changed

export(String) var unlocked_skill = ""

onready var anim_player = $AnimationPlayer
onready var player = $Player
onready var start_positions = $Colliders/StartPositions
onready var enemy_turn_timer = $MaxEnemyTurnTimer
onready var battle_ui = $BattleUI
onready var main_ui = $MainUI

var current_step

enum TURN_STEP {
	INIT, SELECT_START_POS, PLAYER_TURN, ENEMY_TURN, END_WIN, END_LOSS
}

var step_names = [
	"Init", "Select starting position", "Player turn", "Enemy turn", "Victory", "Loss"
]

var _rewards = {
	"exp": 1,
	"gold": 10,
}

var player_moved_this_turn := false

var start_heart_count

func _ready() -> void:
	if not start_positions:
		Console.log_msg("NO START POSITIONS FOUND. PLEASE AVOID THIS EVENT")
		_battle_lost()
		return
	connect("turn_step_changed", battle_ui, "_on_turn_step_changed")
	$Border.modulate.a = 0
	MusicPlayer.play_song("battle")
	main_ui.toggle_moves(false)
	player.set_disable_collision(true)
	player.global_position = start_positions.current_position
	change_current_step(TURN_STEP.INIT)
	anim_player.play("init")
	Courtain.hide()
	
	var hearts = $Hearts.get_children()
	var heart_count = GameData.get_hearts_count()
	for i in range(len(hearts) - heart_count):
		print("popped heart")
		var h = hearts.pop_front()
		h.queue_free()
		
	var enemies = $Enemies.get_children()
	
	start_heart_count = len(hearts)
#	for h in hearts:
#		h.connect("pawn_destroyed", self, "_on_heart_destroyed")
#	for e in enemies:
#		e.connect("pawn_destroyed", self, "_on_pawn_destroyed")
	
	emit_signal("scene_ready")

func _process(delta: float) -> void:
	enemy_turn_timer.stop()
	match current_step:
		TURN_STEP.INIT:
			if not anim_player.is_playing():
				change_current_step(TURN_STEP.SELECT_START_POS)
				start_positions.show()
				return
		TURN_STEP.SELECT_START_POS:
			_update_start_pos()
		TURN_STEP.PLAYER_TURN:
#			_check_win_loss()
			player.handle_input()
			if Input.is_action_just_pressed("action"):
				player.is_moving = true
				player_moved_this_turn = true
				player.cursor.hide()
			if not player.is_moving and player_moved_this_turn:
				change_current_step(TURN_STEP.ENEMY_TURN)
				_check_win_loss()
		TURN_STEP.ENEMY_TURN:
			if enemy_turn_timer.is_stopped():
				enemy_turn_timer.start()
#			_check_win_loss()
			if player.is_moving:
				return
			var enemies = $Enemies.get_children()
			for e in enemies:
				if e == null or not is_instance_valid(e):
					return
#				print("Turn of %s" % e.name)
#				if e.name == "@Peasant@8":
#					pass
				if(_check_win_loss()):
					return
				if e != null and is_instance_valid(e) and not e.is_destroyed:
					e.find_target()
#					if not e.find_target():
#						_check_win_loss()
#						if current_step != TURN_STEP.END_LOSS:
#							print("--- ERROR: No targets for enemy and no win state")
#						return
					if e.find_target():
						e.highlight()
						set_process(false)
						print("Moving %s" %e.name)
#						_check_win_loss()
						yield(e.move(), "completed")
#						_check_win_loss()
						set_process(true)
			if(_check_win_loss()):
				return
				
			change_current_step(TURN_STEP.PLAYER_TURN)
#			_check_win_loss()
			player_moved_this_turn = false
		TURN_STEP.END_WIN:
			_battle_won()
		TURN_STEP.END_LOSS:
			_battle_lost()

onready var debug_restart_timer = $DebugRestartTimer
func _physics_process(delta: float) -> void:
	if current_step != TURN_STEP.ENEMY_TURN:
		return
	if Input.is_action_just_pressed("debug_restart"):
		if debug_restart_timer.is_stopped():
			debug_restart_timer.start()
	if Input.is_action_just_released("debug_restart"):
		debug_restart_timer.stop()


func _apply_rewards():
	var rewards_str = ""
	for r in _rewards:
		GameData.update_player_state(r, _rewards[r])
		rewards_str += "%s (%s) " % [r, _rewards[r]]
	Console.log_msg("Victory. Rewards: %s" % rewards_str)

func change_current_step(new_step) -> void:
	var previous = step_names[current_step] if current_step else ""
	current_step = new_step
	match new_step:
		TURN_STEP.END_LOSS:
			SoundEffects.play_audio("defeat")
		TURN_STEP.END_WIN:
			SoundEffects.play_audio("success")
	emit_signal("turn_step_changed", previous, step_names[new_step])
	

#func _on_heart_destroyed(pawn) -> void:
#	perfect_battle = false
#	print("Pawn %s destroyed" % pawn.name)

func _check_win_loss() -> bool:
	if current_step == TURN_STEP.END_LOSS or current_step == TURN_STEP.END_WIN:
		return true
	var hearts = $Hearts.get_children()
	if len(hearts) < 1 or all_pawns_destroyed(hearts):
		change_current_step(TURN_STEP.END_LOSS)
		player.set_physics_process(false)
		set_process(true)
		return true
	var enemies = $Enemies.get_children()
	if len(enemies) < 1 or all_pawns_destroyed(enemies):
		change_current_step(TURN_STEP.END_WIN)
		player.set_physics_process(false)
		set_process(true)
		return true
	return false

func all_pawns_destroyed(pawns) -> bool:
	for p in pawns:
		if not p.is_destroyed:
			return false
	return true

func get_closest_heart(pos: Vector2, except :Pawn = null) -> Pawn:
	var hearts = $Hearts.get_children()
	if len(hearts) == 0:
		return null
	
	var closest
	for h in hearts:
		if h != except:
			closest = h
			break
	
	for i in range(1, len(hearts)):
		var h = hearts[i]
		if h == except:
			continue
		if h.global_position.distance_squared_to(pos) < closest.global_position.distance_squared_to(pos):
			closest = h
	return closest


func _on_MaxEnemyTurnTimer_timeout() -> void:
	print("Enemy turn exceeded max time of %s. " % enemy_turn_timer.wait_time)
	print("changing to player step")
	change_current_step(TURN_STEP.PLAYER_TURN)
	_check_win_loss()
	set_process(true)

func _update_start_pos():
	if Input.is_action_just_pressed("action"):
		start_positions.hide()
		player_moved_this_turn = false
		change_current_step(TURN_STEP.PLAYER_TURN)
		player.set_disable_collision(false)
		return
	var x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y = Input.get_action_strength("down") - Input.get_action_strength("up")
	start_positions.update_current_position(Vector2(x, y))
	player.global_position = start_positions.current_position

func _battle_won():
	## Pefrect battle
	var hearts = $Hearts.get_children()
	if len(hearts) >= start_heart_count:
		var play_effect = true
		for h in hearts:
			if h.is_destroyed:
				play_effect = false
				break
		if play_effect:
			Courtain.play_effect("perfect-battle")
	###
	GameData.set_battle_stats("--BATTLE", {})
	_apply_rewards()
	set_process(false)
	GameData.load_world_with_state("event")
#	if unlocked_skill != "":
#		GameData.unlock_skill(unlocked_skill)

func _battle_lost():
	set_process(false)
	Console.log_msg("Battle lost. Loading last checkpoint")
	GameData.load_world_with_state("checkpoint")


func _on_DebugRestartTimer_timeout() -> void:
	print("--- DebugRestartTimer timeout. Stuck in battle?")
	print("changing to player step")
	change_current_step(TURN_STEP.PLAYER_TURN)
	_check_win_loss()
	set_process(true)
#	Console.log_msg("Left battle")
#	_battle_lost()

onready var nav2D :Navigation2D = $Colliders/Navigation2D
onready var debug_line :Line2D = $DebugPathLine
onready var debug_dir :Line2D = $DebugPathDir

# return dir leading to target (up, down, left, right, v2.ZERO)
func get_nav_dir(start:Vector2, end:Vector2) -> Vector2:
#	start += Vector2(0, 0) * 0.5 * GameData.TILE_SIZE
	var points = nav2D.get_simple_path(start, end, true)
	debug_line.points = points
	if len(points) < 2:
		return Vector2.ZERO
	debug_dir.points = [points[0], points[1]]
#	debug_dir.points = [start, end]
	var dir = points[1] - points[0]
	dir = get_dir(dir)
		
	return dir


func get_dir(vec :Vector2) -> Vector2:
	var dir = Vector2()
	print("VEC: %s" % vec)
	if abs(vec.x) == abs(vec.y):
		print("Moving in X")
		return Vector2(vec.x, vec.y).normalized()
	if abs(vec.x) >= abs(vec.y):
		dir.x = sign(vec.x)
		dir.y = 0
	else:
		dir.x = 0
		dir.y = sign(vec.y)
	return dir
