extends GdUnitTestSuite

var cm: CommandHistory
var rnd: RandomNumberGenerator


func before() -> void:
	cm = auto_free(CommandHistory.new())
	rnd = auto_free(RandomNumberGenerator.new())
	rnd.seed = int(OS.get_unix_time() / OS.get_system_time_msecs() * 1000)


func before_test() -> void:
	cm._index = 0
	cm._is_at_bottom = false
	cm._stack.clear()


# * Adding
func test_add_single_command() -> void:
	var cmd = auto_free(Command.new())
	cm.add_command(cmd)
	assert_object(cm._stack[cm._index]).is_equal(cmd)


func test_index_after_adding_single_command() -> void:
	var cmd = auto_free(Command.new())
	#assert_int(cm._stack.size()).is_equal(0)
	cm.add_command(cmd)
	assert_int(cm._index).is_equal(0)


func test_stack_size_after_adding_multiple_commands(
	fuzzer := Fuzzers.rangei(1, 999), fuzzer_iterations = 100
) -> void:
	var fuzz = fuzzer.next_value()
	add_many_commands(fuzz)
	assert_int(cm._stack.size()).is_equal(fuzz)


func test_index_after_adding_multiple_commands(
	fuzzer := Fuzzers.rangei(1, 999), fuzzer_iterations = 100
) -> void:
	var fuzz = fuzzer.next_value()
	add_many_commands(fuzz)
	assert_int(cm._index).is_equal(fuzz - 1)


# * undo
func test_index_after_single_undo() -> void:
	var cmd = auto_free(Command.new())
	cm.add_command(cmd)
	cm.undo()
	assert_int(cm._index).is_equal(0)


func test_that_undo_doenst_go_below_zero() -> void:
	add_many_commands(1)
	cm.undo()
	cm.undo()
	cm.undo()

	assert_int(cm._index).is_equal(0)


func test_index_after_multiple_undos(fuzzer := Fuzzers.rangei(1, 99), fuzzer_iterations = 20):
	# dont know why but need to manually reset the stack and index for this test
	# doesnt have anything to do with the CommandHistory itself.
	cm._stack.clear()
	cm._index = 0
	cm._is_at_bottom = false

	var fuzz = fuzzer.next_value()

	add_many_commands(fuzz)

	rnd.randomize()
	var undo_times = rnd.randi_range(0, fuzz)

	for _c in range(0, undo_times):
		cm.undo()

	# need to account for undo not setting index below 0
	var expected_index = max(fuzz - undo_times - 1, 0)
	assert_int(cm._index).is_equal(expected_index)


func test_index_after_multiple_consecutive_undos() -> void:
	rnd.randomize()
	var start = rnd.randi_range(50, 100)
	add_many_commands(start)

	var consecutive_undos = 0

	while consecutive_undos < 1 || cm._index >= 0:
		var undo = rnd.randi_range(0, start)
		if undo <= 0:
			break
		for i in undo:
			cm.undo()
		start -= undo
		if start <= 0:
			break
		consecutive_undos += 1

	var expected_index = max(0, start - 1)
	assert_int(cm._index).is_equal(expected_index)


# * Redo
func test_single_redo_after_undo() -> void:
	rnd.randomize()
	add_many_commands(rnd.randi_range(20, 40))

	cm.undo()
	cm.redo()

	assert_int(cm._index).is_equal(cm._stack.size() - 1)


func test_if_index_goes_not_over_max() -> void:
	rnd.randomize()
	add_many_commands(rnd.randi_range(1, 40))

	for _i in rnd.randi_range(1, 999):
		cm.redo()

	assert_int(cm._index).is_equal(cm._stack.size() - 1)


func test_undo_redo_with_one_item_on_the_stack() -> void:
	add_many_commands(1)

	assert_int(cm._index).is_equal(0)
	assert_bool(cm._is_at_bottom).is_false()

	cm.undo()

	assert_int(cm._index).is_equal(0)
	assert_bool(cm._is_at_bottom).is_true()

	cm.redo()

	assert_int(cm._index).is_equal(0)
	assert_bool(cm._is_at_bottom).is_false()


# * undo -> add
func test_if_stack_gets_resized_when_adding_after_undos() -> void:
	add_many_commands(10)

	cm.undo()
	cm.undo()

	add_many_commands(1)

	assert_array(cm._stack).has_size(9)


func test_if_add_command_adds_commands_as_children():
	var count = 99
	add_many_commands(count)

	assert_array(cm.get_children()).has_size(count)


func test_if_orphaned_commands_get_removed_as_childs():
	var count = 10
	add_many_commands(count)
	assert_array(cm.get_children()).has_size(cm._index + 1)
	rnd.randomize()
	var undos = 5 #rnd.randi_range(10, int(count/2))
	for i in undos:
		cm.undo()
	assert_int(cm._index + 1).is_equal(cm.get_children().size() - undos)
	add_many_commands(10)
	
	var expected_size = (count - undos) + 10
	assert_array(cm.get_children()).has_size(expected_size)


func test_if_undo_add_command_removes_old_commmand():
	add_many_commands(1)
	cm.undo()
	add_many_commands(1)

	assert_array(cm.get_children()).has_size(1)


func add_many_commands(count: int) -> void:
	for _i in range(0, count):
		# var cmd = auto_free(Command.new())
		cm.add_command(auto_free(Command.new()))
