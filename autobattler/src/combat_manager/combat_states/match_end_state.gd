class_name MatchEndState
extends CombatState

var result_menu = preload("res://src/scenes/gui/ResultMenu.tscn").instance()

func _enter() -> void:
	perform_match_end()
	


func perform_match_end() -> void:
	owner.add_child(result_menu)
	var victory = true if self.player.toughness > 0 else false
	if victory: 
		result_menu.player_win()
	else:
		result_menu.player_lose()

func _unhandled_input(event) -> void:
	if result_menu.visible && !result_menu.is_playing():
		if event.is_action_type():
			# TODO transition back to the start
			pass
