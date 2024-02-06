class_name StateMachine
extends Node 

signal state_changed(to, from)


var current_state: State setget _set_current_state, _get_current_state 
var _current_state: State 

var _previous_state: State


var in_transition: bool


# public methods
func get_state(value):
	return get_node(value)

func change_state(value) -> void: 
	self.current_state = get_state(value)


func return_to_previous_state() -> void: 
	if _previous_state: 
		_set_current_state(_previous_state)


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
		if _current_state.returnable:
			_previous_state = _current_state
		else:
			_previous_state = null
		_current_state._exit()
	
	emit_signal("state_changed", value, current_state)
	_current_state = value
	_current_state._enter()

	in_transition = false
	


# passes the unhandled_input to the active state
func _unhandled_input(event):
	if _current_state:
		_current_state.unhandled_input(event)

