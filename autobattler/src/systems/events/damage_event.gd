class_name DamageEvent
extends GameEvent


var amount: int 
var targets: Array setget set_targets
var viewable: bool 


func set_targets(value: Array) -> void:
    if !targets:
        targets = []
    targets += value

func _init() -> void: 
    _event_class = "DamageEvent"

func add_target(target) -> void: 
    if !targets:
        targets = []
    if target is GameCard or target is PlayerBase:
        targets.append(target)
        return
    push_error(str(target.get_class(), " is not a valid type"))