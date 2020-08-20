extends Node2D

signal scene_ready
signal turn_step_changed

onready var anim_player = $AnimationPlayer
onready var player = $Player
onready var start_positions = $StartPositions
onready var enemy_turn_timer = $MaxEnemyTurnTimer
onready var battle_ui = $BattleUI

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

func _ready() -> void:
	connect("turn_step_changed", battle_ui, "_on_turn_step_changed")
	
	MusicPlayer.play_song("battle")
	player.set_disable_collision(true)
	player.global_position = start_positions.current_position
	change_current_step(TURN_STEP.INIT)
	anim_player.play("init")
	Courtain.hide()
	
	var hearts = $Hearts.get_children()
	var heart_count = GameData.get_hearts_count()
#	print("h below par: %s" % GameData.get_hearts_below_par())
	for i in range(len(hearts) - heart_count):
		print("popped heart")
		var h = hearts.pop_front()
		h.queue_free()
		
	var enemies = $Enemies.get_children()
	for h in hearts:
		h.connect("pawn_destroyed", self, "_on_pawn_destroyed")
	for e in enemies:
		e.connect("pawn_destroyed", self, "_on_pawn_destroyed")
	
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
			if Input.is_action_just_pressed("action"):
				start_positions.hide()
				player_moved_this_turn = false
				change_current_step(TURN_STEP.PLAYER_TURN)
				player.set_disable_collision(false)
				return
			var x = Input.get_action_strength("right") - Input.get_action_strength("left")
			var y = Input.get_action_strength("up") - Input.get_action_strength("down")
			start_positions.update_current_position(Vector2(x, y))
			player.global_position = start_positions.current_position
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
			enemy_turn_timer.start()
#			_check_win_loss()
			if player.is_moving:
				return
			var enemies = $Enemies.get_children()
			for e in enemies:
				if(_check_win_loss()):
					return
				if e != null and is_instance_valid(e):
					if not e.find_target():
#						_check_win_loss()
						if current_step != TURN_STEP.END_LOSS:
							print("--- ERROR: No targets for enemy and no win state")
						return
					if e.target:
						set_process(false)
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
			var rewards_str = ""
			for r in _rewards:
				GameData.update_player_state(r, _rewards[r])
				rewards_str += "%s (%s) " % [r, _rewards[r]]
			set_process(false)
			Console.log_msg("Battle won. Rewards: %s" % rewards_str)
			GameData.load_world_with_state("event")
		TURN_STEP.END_LOSS:
			set_process(false)
			Console.log_msg("Battle lost. Loading last checkpoint")
			GameData.load_world_with_state("checkpoint")

func change_current_step(new_step) -> void:
	var previous = step_names[current_step] if current_step else ""
	current_step = new_step
	match new_step:
		TURN_STEP.END_LOSS:
			SoundEffects.play_audio("defeat")
		TURN_STEP.END_WIN:
			SoundEffects.play_audio("success")
	emit_signal("turn_step_changed", previous, step_names[new_step])
	

func _on_pawn_destroyed(pawn) -> void:
	print("Pawn %s destroyed" % pawn.name)
#	_check_win_loss()

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
	change_current_step(TURN_STEP.PLAYER_TURN)
	set_process(true)
