class_name TestStateMachine
extends GdUnitTestSuite

var fsm: StateMachine
var state1: State
var state2: State


func before() -> void:
	fsm = auto_free(StateMachine.new())

	state1 = auto_free(State.new())
	state1.name = "State1"

	state2 = auto_free(State.new())
	state2.name = "State2"

	add_child(fsm)
	fsm.add_child(state1)
	fsm.add_child(state2)

	state2.owner = fsm
	state1.owner = fsm


func before_test() -> void:
	fsm._current_state = null
	fsm.in_transition = false


func test_if_states_have_an_owner() -> void:
	for s in [state1, state2]:
		assert_object(s.owner).is_not_null()


func test_if_states_owner_is_fsm() -> void:
	for s in [state1, state2]:
		assert_object(s.owner).is_equal(fsm)


func test_fsm_cannot_change_in_wrong_state() -> void:
	fsm.change_state("NoState")
	assert_object(fsm.current_state).is_null()


func test_fsm_can_change_in_child_state() -> void:
	fsm.change_state("State1")
	assert_object(fsm.current_state).is_equal(state1)
