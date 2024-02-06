class_name State
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
	var all_signals = get_incoming_connections()

	if all_signals.size() < 1:
		return

	for s in all_signals:
		s.source.disconnect(s.signal_name, self, s.method_name)


func unhandled_input(_event: InputEvent) -> void:
	pass
