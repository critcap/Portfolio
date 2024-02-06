class_name State 
extends Node

# base class for all states
export (bool) var returnable: bool = false

signal entered
signal exited

# virtual methods

func _enter() -> void:
	_connect_signals()
	emit_signal("entered")

func _exit() -> void:
	_disconnect_signals()
	emit_signal("exited")

func queue_free() -> void:
	_disconnect_signals() 
	.queue_free()

func _connect_signals() -> void:
	pass

func _disconnect_signals() -> void:
	pass

func unhandled_input(_event: InputEvent) -> void:
	pass
