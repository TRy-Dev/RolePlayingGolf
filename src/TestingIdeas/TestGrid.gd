extends Node2D

signal pawn_selected(previous, current)


onready var world = $GridWorld

var selected_pawn :Pawn

var debug_path_points = []

var is_pawn_moving = false

func _ready():
	connect("pawn_selected", world, "_on_pawn_selected")

func _process(delta):
	if Input.is_action_just_pressed("debug_restart"):
		SceneController.reload_current()
		DebugOverlay.clear_stats()

	if is_pawn_moving:
		return
	
	_highlight_selected_path_to_mouse()
	
	if Input.is_action_just_pressed("fire"):
		_move_pawns_turn()
	
	if Input.is_action_just_pressed("click"):
		_debug_change_or_move_selected_pawn()
		

func _debug_change_or_move_selected_pawn():
	var click_pos = get_global_mouse_position()
	var click_grid_pos = Vector2(round(click_pos.x / GlobalConstants.TILE_SIZE),
			round(click_pos.y / GlobalConstants.TILE_SIZE))
			#world.world_to_grid(click_pos)
	var click_pawn = world.get_pawn_at(click_grid_pos)
	if click_pawn:
		if selected_pawn:
			selected_pawn.set_selected(false)
		emit_signal("pawn_selected", selected_pawn, click_pawn)
		selected_pawn = click_pawn
		$CameraController.set_target(selected_pawn)
		click_pawn.set_selected(true)
		
	elif selected_pawn:
#			var pos_from = world.grid_to_world(selected_pawn.grid_position)
		var pos_from = selected_pawn.grid_position
		var pos_to = get_global_mouse_position() / GlobalConstants.TILE_SIZE
		# Move half_tile towards target to ensure proper a_star point is selected
		# pos_from += (pos_to - pos_from).normalized() * 0.501 * GlobalConstants.TILE_SIZE
		var points = world.get_nav_path(pos_from, pos_to)
		
		if len(points) > 0:
			is_pawn_moving = true
			for i in range(len(points)):
				var pawn_grid_from = selected_pawn.grid_position
				var pawn_grid_to = points[i]
				world.move_pawn(pawn_grid_from, pawn_grid_to)
				yield(get_tree().create_timer(GlobalConstants.MOVE_TIME), "timeout")
			is_pawn_moving = false

func _move_pawns_turn():
	print("Move pawns turn. to be implemented")

func _highlight_selected_path_to_mouse():
	if selected_pawn:
		var pos_from = selected_pawn.grid_position
		var pos_to = get_global_mouse_position() / GlobalConstants.TILE_SIZE
		debug_path_points = world.get_nav_path(pos_from, pos_to)
		update()

func _draw():
	for i in range(len(debug_path_points) - 1):
		var pos_from = GlobalConstants.TILE_SIZE * (debug_path_points[i] + 0.5 * Vector2.ONE)
		var pos_to = GlobalConstants.TILE_SIZE * (debug_path_points[i + 1] + 0.5 * Vector2.ONE)
		var color = Color.blue.linear_interpolate(Color.yellow, float(i) / len(debug_path_points))
		draw_line(pos_from, pos_to, color, 2.0)
