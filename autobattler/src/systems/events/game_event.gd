class_name GameEvent
extends GameEventBase



var id: int
var player: PlayerBase
var priority: int
var order_of_play: int
var is_cancelled: bool

# * Phases
var prepare: Phase
var perform: Phase
var cancel: Node

# * public methods

func cancel_event() -> void:
	is_cancelled = true


func _init() -> void: 
	_event_class = "GameEvent"
	id = get_instance_id()
	prepare = Phase.new(self, funcref(self, "_on_prepare_key_frame"))
	perform = Phase.new(self, funcref(self, "_on_perform_key_frame"))


func _on_perform_key_frame() -> void: 
	GlobalSignals.post_event_signal("perform", self)

func _on_prepare_key_frame() -> void: 
	GlobalSignals.post_event_signal("prepare", self)

func _on_cancel_key_frame() -> void: 
	GlobalSignals.post_event_signal("cancel", self)
