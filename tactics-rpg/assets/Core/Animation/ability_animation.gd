class_name AbilityAnimation
extends Node


signal animation_finished


func play() -> void:
	emit_signal("animation_finished")
	pass
