class_name Validator
extends Node

# region signals

# on the test has started
signal started
# when the test has finished
signal finished
# when the word is completed
signal word_passed

signal wrong_letter_input(code)
signal correct_letter_input(code)

# endregion

# region Properties
var index: int setget , get_index
var scancodes: PoolIntArray
var has_started: bool = false
var _index: int = 0

# endregion

# region Setters & Getters


func get_index() -> int:
	return _index


# endregion


func setup(codes: PoolIntArray) -> void:
	scancodes = codes
	_index = 0
	has_started = false


func validate(event: InputEventKey) -> void:
	if !has_scancodes() || is_ignored_key(event):
		return

	var code = (
		event.physical_scancode
		if OS.get_name() == "HTML5" && event.scancode >= 200
		else event.scancode
	)

	# fires on first key input
	if _index == 0 && !has_started:
		has_started = true
		emit_signal("started")

	if code != scancodes[_index]:
		emit_signal("wrong_letter_input", code)
		return

	emit_signal("correct_letter_input", code)
	if scancodes[_index] == KEY_SPACE:
		emit_signal("word_passed")
	_index += 1

	if _index >= scancodes.size():
		emit_signal("finished")


func has_scancodes() -> bool:
	return scancodes != null && !scancodes.empty() && _index < scancodes.size()


func is_ignored_key(event: InputEventKey) -> bool:
	if event.command || event.control || event.shift || event.alt:
		return true
	var stringcode = OS.get_scancode_string(event.get_scancode_with_modifiers())
	match stringcode.to_lower():
		"shift", "command", "control", "alt":
			return true
	return false
