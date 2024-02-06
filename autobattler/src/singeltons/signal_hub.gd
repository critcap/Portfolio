extends Node

signal prepare_game_event
signal perform_game_event
signal cancel_game_event
signal validate_game_event

signal prepare_damage_event
signal perform_damage_event
signal cancel_damage_event
signal validate_damage_event

signal prepare_death_event
signal perform_death_event
signal cancel_death_event
signal validate_death_event

signal prepare_draw_event
signal perform_draw_event
signal cancel_draw_event
signal validate_draw_event

signal prepare_attack_event
signal perform_attack_event
signal cancel_attack_event
signal validate_attack_event

signal check_for_death

var warning setget set_warning

func set_warning(error) -> void:
	if error != 0:
		push_warning(str("ERROR: ", error))


func post_event_signal(prefix: String, event: GameEvent) -> void:
	if  event is GameEvent:
		var _name = event.get_class()
		_name = str(_name.left(_name.find("Event")).to_lower() + "_" + "event")
		var signal_string = str(prefix + "_" + _name)
		emit_signal(signal_string, event)

	
func filter_for_turn_events(class_string: String) -> void:
	if !"turn" in class_string:
		return
	var filter = class_string.split("turn")
	pass #emit_signal()
