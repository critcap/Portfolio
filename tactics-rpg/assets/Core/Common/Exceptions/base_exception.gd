class_name BaseException
extends Reference

var toggle: bool
var default_toggle: bool setget set_toggle

func set_toggle(_value) -> void: pass


func _init(default: bool) -> void:
	default_toggle = default
	toggle = default_toggle


func flip_toggle() -> void:
	toggle = !default_toggle