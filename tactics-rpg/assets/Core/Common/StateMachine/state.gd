class_name State, "res://assets/Core/Common/StateMachine/book.png"
extends Node

# base class for all states
signal entered
signal exited

# virtual methods


func enter() -> void:
	connect_signals()
	emit_signal("entered")


func exit() -> void:
	disconnect_signals()
	emit_signal("exited")


func queue_free() -> void:
	disconnect_signals()
	.queue_free()


func connect_signals() -> void:
	pass


func disconnect_signals() -> void:
	pass


func unhandled_input(_event: InputEvent) -> void:
	pass
