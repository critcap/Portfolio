extends GdUnitTestSuite

var Battle = load("res://_developer/Demos/Battle/Demo_Attack.tscn")

var scene
var spy
var runner

var bc
var ability
var command


func before():
	scene = Battle.instance()
	bc = scene.get_node("BattleController")
	runner = scene_runner(scene)


func before_test():
	bc.in_transition = false
	

func test_going_into_target_selection():
	yield(
		runner.simulate_until_object_signal(bc, "state_changed", "SelectCommandState"), "completed"
	)
	runner.simulate_key_pressed(KEY_K)
	assert_int(get_state_hash()).is_equal(hash("SelectTargetState"))


func test_selecting_melee_target():
	if get_state_hash() != hash("SelectTargetState"):
		bc.change_state("SelectCommandState")
		
		
	var possible_targets: Array = get_units_in_range(1)

	if possible_targets.empty():
		var enemy = get_enemy()
		var free_tiles = get_free_tile_in_range_of_target(enemy)
		bc.turn.subject.get_node("Pawn").place(free_tiles[0])

		runner.simulate_key_pressed(KEY_K)
		yield(get_tree(), "idle_frame")
	bc.in_transition = true
	for key in [KEY_W, KEY_D, KEY_S, KEY_A]:
		runner.simulate_key_press(key)
		runner.simulate_key_press(KEY_ENTER)

	assert_array(bc.command.ability.targets).is_not_empty()


func test_performing_attack_hit():
	var possible_targets: Array = get_units_in_range(1)
	
	if possible_targets.empty():
		var enemy = get_enemy()
		var free_tiles = get_free_tile_in_range_of_target(enemy)
		bc.turn.subject.get_node("Pawn").place(free_tiles[0])
	
	if get_state_hash() == hash("SelectTargetState"):
		bc.change_state("SelectCommandState")
		yield(get_tree(), "idle_frame")
		runner.simulate_key_press(KEY_K)
		yield(get_tree(), "idle_frame")
	
	for key in [KEY_W, KEY_D, KEY_S, KEY_A]:
		runner.simulate_key_press(key)
		runner.simulate_key_press(KEY_ENTER)
		bc.in_transition = true

	var attacker = bc.turn.subject
	
	for target in bc.command.ability.targets:	
		target = target.content.owner
		target.get_node("Stats").set_value(StatTypes.EVA, 0)
	bc.in_transition = false
	runner.simulate_key_press(KEY_ENTER)

	yield(runner.simulate_until_object_signal(bc.command.ability, "perform_completed"), "completed")
	var atk = attacker.get_node("Stats").get_value(StatTypes.ATK)
	
	for target in bc.command.ability.targets:
		target = target.content.owner
		var def = target.get_node("Stats").get_value(StatTypes.DEF)

		var expected_health = target.get_node("Health").maxhp - (atk - def / 2)
		assert_int(target.get_node("Health").current).is_equal(expected_health)

func after():
	bc.free()
	scene.free()


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


func get_free_tile_in_range_of_target(target: Node, distance: int = 1) -> Array:
	var mover = target.get_node("Movement")
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
