extends GdUnitTestSuite

var Battle = preload("res://tests/BattleScene/TestMovementSequence.tscn")

var scene
var runner

var bc
var command
var target: Tile

func before():
	scene = Battle.instance()
	bc = scene.get_node("BattleController")
	runner = scene_runner(scene)


func after():
	for tile in bc.board._tiles.values():
		tile.free()
	bc.free()
	scene.free()

func test_going_into_movement_target_state():
	yield(
		runner.simulate_until_object_signal(bc, "state_changed", "SelectCommandState"), "completed"
	)
	runner.simulate_key_pressed(KEY_M)
	assert_int(get_state_hash()).is_equal(hash("SelectMovementState"))
	assert_bool(bc.command is MoveCommand).is_true()


func test_walking_onto_an_empty_tile():
	var mover = bc.turn.subject.get_node("Movement")
	var free_tiles = mover.get_tiles_in_range(bc.board)
	var rng = RandomNumberGenerator.new()
	while !target:
		rng.randomize()
		var possible = free_tiles[rng.randi_range(0, free_tiles.size() - 1)]
		if possible.content||!possible.previous:
			continue
		target = possible

	assert_object(target.previous).is_not_null()


func test_selecting_tile_out_of_bounds():
	var _mover = bc.turn.subject.get_node("Movement")
	var free_tiles = _mover.get_tiles_in_range(bc.board)	
	for i in bc.board._tiles.values():
		if free_tiles.find(i):
			continue
		bc.cursor.position = i.position
	
	# blocks battle controller from transition into next state
	bc.in_transition = true	
	runner.simulate_key_press(KEY_ENTER)
	assert_object(bc.command.destination).is_not_equal(bc.tile)
	assert_object(bc.command.destination).is_null()
	
	
func test_selecting_tile_that_is_occupied():
	var move_range = bc.turn.subject.get_node("Movement").move_range
	var units: = get_units_in_range(move_range)
	
	if units.empty():
		var enemy = get_enemy()
		var suitable_tiles = get_free_tile_in_range_of_target(bc.turn.subject, move_range)
		enemy.get_node("Pawn").place(suitable_tiles[0])
		units.append(enemy)
	
	var _mover = bc.turn.subject.get_node("Movement")
	var free_tiles = _mover.get_tiles_in_range(bc.board)	
	
	bc.cursor.position = units[0].get_node("Pawn").tile.position
	
	bc.in_transition = true	
	
	runner.simulate_key_press(KEY_ENTER)
	assert_object(bc.command.destination).is_not_equal(bc.tile)
	assert_object(bc.command.destination).is_null()
	
	
func test_movement_to_valid_location(timeout=2000):
	var move_range = bc.turn.subject.get_node("Movement").move_range
	var suitable_tiles = get_free_tile_in_range_of_target(bc.turn.subject, move_range)
	var _mover = bc.turn.subject.get_node("Movement")
	var free_tiles = _mover.get_tiles_in_range(bc.board)	
	
	if !suitable_tiles.find(target):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		target = suitable_tiles[rng.randi_range(0, suitable_tiles.size() - 1)]
	
	
	
	# allow battle controller to change states
	bc.in_transition = false
	bc.cursor.position = target.position
	
	bc.current_state.on_accept()
	# tweening apperently not supported by gdunit3 atm
	#yield(runner.simulate_until_object_signal(_mover, "traverse_finished"), "completed")
	bc.turn.subject.get_node("Pawn").place(target)

	assert_bool(_mover.unit.tile.position == target.position).is_true()
	
	
#region utility functions
func get_state_hash() -> int:
	return hash(bc.current_state.name)


func get_units_in_range(distance: int) -> Array:
	var subject = bc.turn.subject
	var tiles = subject.get_node("Movement").get_tiles_in_range(bc.board)

	var filtered_tiles = []

	for tile in tiles:
		if tile.distance > distance:
			continue
		if !tile.content || tile.content.owner == bc.turn.subject:
			continue
		filtered_tiles.append(tile.content.owner)
	return filtered_tiles


func get_free_tile_in_range_of_target(_target: Node, distance: int = 1) -> Array:
	var mover = _target.get_node("Movement")
	var tiles = mover.get_tiles_in_range(bc.board)

	var filtered_tiles = []

	for tile in tiles:
		if tile.distance > distance:
			continue
		if tile.content:
			continue
		filtered_tiles.append(tile)
	return filtered_tiles


func get_enemy() -> Node:
	var index = bc.units.find(bc.turn.subject)
	return bc.units[index - 1]
#endregion
