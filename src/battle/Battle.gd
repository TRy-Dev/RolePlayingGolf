extends Node2D

onready var anim_player = $AnimationPlayer
onready var player = $Player
onready var start_positions = $StartPositions

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
	player.set_disable_collision(true)
	player.global_position = start_positions.current_position
	current_step = TURN_STEP.INIT
	anim_player.play("init")
	Courtain.hide()
	
	var hearts = $Hearts.get_children()
	var enemies = $Enemies.get_children()
	for h in hearts:
		h.connect("pawn_destroyed", self, "_on_pawn_destroyed")
	for e in enemies:
		e.connect("pawn_destroyed", self, "_on_pawn_destroyed")

func _process(delta: float) -> void:
	$Label.text = step_names[current_step]
	match current_step:
		TURN_STEP.INIT:
			if not anim_player.is_playing():
				current_step = TURN_STEP.SELECT_START_POS
				start_positions.show()
				return
		TURN_STEP.SELECT_START_POS:
			if Input.is_action_just_pressed("action"):
				start_positions.hide()
				player_moved_this_turn = false
				current_step = TURN_STEP.PLAYER_TURN
				player.set_disable_collision(false)
				return
			var x = Input.get_action_strength("right") - Input.get_action_strength("left")
			var y = Input.get_action_strength("up") - Input.get_action_strength("down")
			start_positions.update_current_position(Vector2(x, y))
			player.global_position = start_positions.current_position
		TURN_STEP.PLAYER_TURN:
			_check_win_loss()
			player.handle_input()
			if Input.is_action_just_pressed("action"):
				player_moved_this_turn = true
				player.cursor.hide()
			if not player.is_moving and player_moved_this_turn:
				current_step = TURN_STEP.ENEMY_TURN
		TURN_STEP.ENEMY_TURN:
			_check_win_loss()
			if player.is_moving:
				return
			var enemies = $Enemies.get_children()
			for e in enemies:
				if e != null and is_instance_valid(e):
					if e.target:
						print("Schedule %s to move" % e.name)
						set_process(false)
						_check_win_loss()
						print("start move")
						yield(e.move(), "completed")
						print("end move")
						_check_win_loss()
						set_process(true)
			current_step = TURN_STEP.PLAYER_TURN
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

func _on_pawn_destroyed(pawn) -> void:
	print("Pawn %s destroyed" % pawn.name)
	_check_win_loss()

func _check_win_loss() -> void:
	if current_step == TURN_STEP.END_LOSS or current_step == TURN_STEP.END_WIN:
		return
	var hearts = $Hearts.get_children()
	if len(hearts) < 1:
		current_step = TURN_STEP.END_LOSS
		player.set_physics_process(false)
		set_process(true)
		return
	var enemies = $Enemies.get_children()
	if len(enemies) < 1:
		current_step = TURN_STEP.END_WIN
		player.set_physics_process(false)
		set_process(true)
		return

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
