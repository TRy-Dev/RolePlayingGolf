extends Node

onready var sleep_timer = $SleepTimer

const MAX_COMMANDS_SIZE = 1000
var _command_history := []
var _world = null

func init(world):
	_world = world
	sleep_timer.wait_time = GlobalConstants.MOVE_TIME

func on_player_input(dir: Vector2) -> void:
	if dir.length_squared() < Math.EPSILON:
		return
	if not sleep_timer.is_stopped():
		return
	_world.validate_tilemap_and_pawns_equal()
	var new_commands = _get_command_chain(dir)
#	GameData.debug_commands(new_commands)
	if not new_commands:
		return
	_command_history.append(new_commands)
	# Limit history to MAX_COMMANDS_SIZE commands
	if len(_command_history) > MAX_COMMANDS_SIZE:
		print("More than %s commands. Cutting oldest!" % MAX_COMMANDS_SIZE)
		_command_history = _command_history.slice(len(_command_history) - MAX_COMMANDS_SIZE, len(_command_history) - 1)
	for c in new_commands:
		c.execute()
	sleep_timer.start()

func undo() -> void:
	if not sleep_timer.is_stopped():
		return
	if len(_command_history) > 0:
		_world.validate_tilemap_and_pawns_equal()
		var last_commands = _command_history.pop_back()
		last_commands.invert()
#		GameData.debug_commands(last_commands)
		for c in last_commands:
			c.undo()
	sleep_timer.start()

func _get_command_chain(dir) -> Array:
	var player = _world.player
	var pos_from = player.get_grid_pos()
	var pos_to = pos_from + dir
	# Is walking straight into non-walkable tile
	if not _world.is_tile_walkable(pos_to):
		return []
	# Tile in front is walkable and has pawn
	var command_chain = []
	var total_weight := 0
	while true:
		var pawn_from = _world.get_pawn_at(pos_from)
		var pawn_to = _world.get_pawn_at(pos_to)
		if not pawn_from:
			return []
		if not pawn_to:
			if _world.is_tile_walkable(pos_to):
				command_chain.append(Commands.MoveCommand.new(_world, pos_from, pos_to))
				break
			else:
				return []
		if not _world.is_tile_walkable(pos_from) or not _world.is_tile_walkable(pos_to):
			return []
		var interaction_commands = pawn_to.get_interaction_commands(_world, pawn_from)
		if not interaction_commands:
			return []
		if len(interaction_commands) == 1 and \
				interaction_commands[0] is Commands.MoveCommand:
			total_weight += pawn_to.get_attribute("weight")
		for c in interaction_commands:
			if not c:
				if total_weight > player.strength:
					return []
				command_chain.invert()
				return command_chain
			command_chain.append(c)
		pos_from = pos_to
		pos_to += dir
	if total_weight > player.strength:
		return []
	command_chain.invert()
	return command_chain
