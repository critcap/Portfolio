class_name Driver
extends Node

var _normal: int
var _special: = 0

var current: int setget , get_current

func get_current() -> int:
	return _special if _special != Drivers.NONE else _normal