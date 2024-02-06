extends GdUnitTestSuite

# units
const UNIT_COUNT := 6
const START_WAIT := 1000
const SEED: int = 9191919199

var tc: TurnController
var rng: RandomNumberGenerator
var fs: GDScriptFunctionState


func before():
	tc = auto_free(TurnController.new())
	tc.units = []

	rng = auto_free(RandomNumberGenerator.new())
	rng.seed = SEED
	for i in UNIT_COUNT:
		var battler = auto_free(Node.new())
		var stats = auto_free(Stats.new())
		stats.name = "Stats"
		battler.add_child(stats)
		rng.randomize()
		var rng_speed = rng.randi_range(16, 24)
		stats.set_value(StatTypes.SPD, rng_speed)
		stats.set_value(StatTypes.WAIT, START_WAIT)
		tc.units.append(battler)


func before_test() -> void:
	#reset wait time
	for i in tc.units:
		i.get_node("Stats").set_value(StatTypes.WAIT, START_WAIT)


func after_test():
	tc.turn.free()


func test_properties_at_beginning() -> void:
	assert_object(tc.turn).is_null()
	assert_int(tc.units.size()).is_equal(UNIT_COUNT)
	for i in tc.units:
		assert_int(tc.get_wait_counter(i)).is_equal(START_WAIT)


func test_if_subject_wait_time_below_zero():
	tc.advance_turn()
	assert_int(tc.get_wait_counter(tc.turn.subject)).is_less(0)
	tc.turn.free()


func test_if_advance_turn_results_in_a_subject() -> void:
	tc.advance_turn()
	assert_object(tc.turn.subject).is_not_null()


func test_if_the_first_is_the_really_the_lowest_wt():
	fs = tc.advance_turn()
	var subject = tc.turn.subject
	var checker: bool

	for i in tc.units:
		if i == subject:
			continue
		checker = tc.get_wait_counter(subject) < tc.get_wait_counter(i)

	assert_bool(checker).is_true()
