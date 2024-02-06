extends Button


func _gui_input(event):
	if event.is_action_pressed("ui_up") || event.is_action_pressed("ui_down"):
		pressed = !pressed
		accept_event()
