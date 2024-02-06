class_name Stats
extends Node

signal stat_has_changed(type, value)

var _data: Dictionary = {}


func set_value(type: int, value: int) -> void:
	if !_data.has(type):
		_data[type] = 0

	if _data[type] == value:
		return

	_data[type] = value
	emit_signal("stat_has_changed", type, value)


func get_value(type: int) -> int:
	return _data[type] if _data.has(type) else 0
