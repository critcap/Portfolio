class_name DrawCardsEvent
extends GameEvent

var amount: int 
var cards: Array
var viewable: bool 

func _init() -> void:
    _event_class = "DrawEvent"