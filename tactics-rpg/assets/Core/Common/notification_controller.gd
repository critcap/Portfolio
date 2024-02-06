extends Node

signal _event_called(_event, _args, _sender)

var _events: = {}
var _subscriber: = {}


func subscribe(event: String, subscriber: Node, handler: FuncRef, sender: Node = null) -> void:
	
	if !_subscriber.has(subscriber):
		_subscriber[subscriber] = {}

	if !_events.has(event):
		_events[event] = 1

	_events[event] = false

	if _subscriber[subscriber].has(event) && _subscriber[subscriber][event] != null:
		push_warning("Already subscribed to event: " + event)
		return


	var sub = subscribtion.new(event, handler, sender)
	connect("_event_called", sub, "on_event_call")
	add_child(sub)

	_subscriber[subscriber][event] = sub


func unscubscribe(event, subscriber: Node) -> void:
	if !_events.has(event) || !_subscriber.has(subscriber):
		return

	if _subscriber[subscriber].has(event) && _subscriber[subscriber][event] != null:
		_subscriber[subscriber][event].free()

	_subscriber[subscriber].erase(event)


func clear() -> void:
	_events.clear()
	_subscriber.clear()
	for child in get_children():
		child.free()


func call_subscribtion(event: String, args = null, sender: Node = null) -> void:
	emit_signal("_event_called", event, args, sender)


class subscribtion extends Node:
	var event: String
	var handler: FuncRef
	
	var is_specific: bool = false
	var sender: Node

	func _init(_ev: String, _handler: FuncRef, _sender: Node = null) -> void:
		event = _ev
		handler = _handler
		
		if _sender != null:
			is_specific = true
			sender = _sender


	func on_event_call(_ev: String, _args, _sender) -> void:
		if hash(event) != hash(_ev):
			return

		if !is_specific || (is_specific && sender == _sender):
			if !handler.is_valid():
				queue_free()
				return
	
			handler.call_func(_args)
