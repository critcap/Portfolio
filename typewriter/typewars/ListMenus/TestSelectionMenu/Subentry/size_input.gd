extends SpinBox


# SpinBox is kinda busted because it creates a LineInput node underneath which
# holds the focus instead of the SpinBox Node. Thus _gui_input() cannot be used.
func _ready():
	var line_edit = get_line_edit()
	line_edit.clear_button_enabled = false
	line_edit.shortcut_keys_enabled = false
	line_edit.middle_mouse_paste_enabled = false
	line_edit.selecting_enabled = false
	line_edit.connect("gui_input", self, "_on_line_edit_gui_input")
	max_value = 999


func _on_line_edit_gui_input(event):
	if event.is_action_pressed("ui_up") || event.is_action_pressed("ui_down"):
		_on_action_pressed_vertical(event)
	if event.is_action_pressed("ui_left") || event.is_action_pressed("ui_right"):
		_on_action_pressed_horizontal(event)
	if event.is_action_pressed("ui_accept") && event is InputEventWithModifiers && event.shift:
		owner.on_ui_accept()

	get_tree().set_input_as_handled()


func _on_action_pressed_vertical(event: InputEvent) -> void:
	var increment = 1
	increment *= -1 if event.is_action_pressed("ui_down") else 1
	increment *= 10 if event is InputEventWithModifiers && event.shift else 1
	value = int(max(min_value, value + increment))


func _on_action_pressed_horizontal(event: InputEvent) -> void:
	var line_edit = get_line_edit()
	if event.is_action_pressed("ui_left"):
		var focus_left = get_node(focus_neighbour_left)
		if focus_left:
			focus_left.grab_focus()
	if event.is_action_pressed("ui_right"):
		var focus_right = get_node(line_edit.focus_neighbour_right)
		if focus_right:
			focus_right.grab_focus()
