class_name DurationStatusCondition
extends StatusCondition


var duration: int
var trigger: String


func _init(_duration: int, _trigger: String) -> void:
	duration = _duration
	trigger = _trigger

func _ready():
	Notifications.subscribe(trigger, self, funcref(self, "on_turn_trigger"))

func on_turn_trigger(args):
	var turn = args as Turn
	
	var subject = turn.subject
	var _owner = self.owner
	if turn.subject != self.owner:
		return
	
	duration -= 1
	if duration <= 0:
		remove()
