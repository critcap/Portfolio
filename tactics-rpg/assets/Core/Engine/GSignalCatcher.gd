extends Node

var catch setget set_error


func set_error(value: int) -> void:
	catch = value
	if value != 0:
		print(value)
