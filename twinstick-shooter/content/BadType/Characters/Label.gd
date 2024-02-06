extends Label

func _on_character_controller_state_changed(state):
	text = state.name
