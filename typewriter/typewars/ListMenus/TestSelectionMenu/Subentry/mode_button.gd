extends Button


func _gui_input(event):
	if event.is_action_pressed("ui_up") || event.is_action_pressed("ui_down"):
		pressed = !pressed
		accept_event()


func _on_Mode_toggled(button_pressed: bool):
	text = TypingTestModes.mode_to_string(int(button_pressed))
