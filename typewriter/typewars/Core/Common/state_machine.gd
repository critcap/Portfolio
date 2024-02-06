class_name StateMachine
extends Node

signal state_changed(state_name)

var in_transition: bool
var current_state: State setget _set_current_state, _get_current_state
var _current_state: State


# public methods
func get_state(value):
	return $States.get_node(value)


func change_state(value) -> void:
	if !get_state(value):
		push_error(str("This StateMachine doesnt have a State of Type ", value))
		return
	self.current_state = get_state(value)


# virtual and private methods
func _set_current_state(value: State) -> void:
	_transition(value)


func _get_current_state() -> State:
	return _current_state


func _transition(value: State) -> void:
	if (_current_state == value) || in_transition:
		if in_transition:
			if !OS.has_feature("standalone"):
				print("transitioning")
		return

	in_transition = true

	if _current_state:
		_current_state.exit()

	_current_state = value
	_current_state.enter()
	emit_signal("state_changed", _current_state.name)

	in_transition = false


# passes the unhandled_input to the active state
func _unhandled_input(event):
	if _current_state:
		_current_state.unhandled_input(event)
