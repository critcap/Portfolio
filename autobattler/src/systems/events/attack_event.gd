class_name AttackEvent
extends GameEvent

var attacker: GameCard
var target: Node

func _init() -> void:
    _event_class = "AttackEvent"

