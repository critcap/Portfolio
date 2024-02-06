extends HBoxContainer

var debug_hints := {"debug": "debug"}
onready var selection_hints := {
	"subentry": tr("HINT_SUBENTRY"),
	"ui_accept": tr("HINT_START_TEST"),
	"show_help": tr("HINT_SHOW_HELP")
}
onready var test_hints := {
	"reload_test": tr("HINT_RELOAD"),
	"quit_test": tr("HINT_QUIT"),
	"show_help": tr("HINT_SHOW_HELP")
}
onready var end_hints := {
	"reload_test": tr("HINT_RELOAD"), "quit_test": tr("HINT_QUIT"), "ui_accept": tr("HINT_PROCEED")
}


# region Methods
func create_hints_from_mapping(hints: Dictionary) -> Array:
	var labels = []

	for key in hints.keys():
		if !InputMap.has_action(key):
			continue

		var binds = ProjectSettings.get_setting(str("input/", key))
		if binds.values().empty() || binds.events.empty():
			continue

		# get scancode text from bound events
		# TODO expand filtering for actions with more binds
		if !(binds.events[0] is InputEventKey):
			continue
		var scancode = binds.events[0].get_scancode_with_modifiers()
		var scancode_string := OS.get_scancode_string(scancode)

		# build label and label text
		var hint_label = Button.new()
		hint_label.text = str(scancode_string, ":", hints[key]).to_lower()
		labels.append(hint_label)

	# adds debug options if in debug mode
	return labels


func refresh(labels: Array) -> void:
	if !get_children().empty():
		for i in get_children():
			remove_child(i)
			i.free()

	for hint in labels:
		add_child(hint)
	visible = true


# endregion


# region Signal Listeners
func _on_TestController_state_changed(state_name):
	if state_name == "SelectTestState":
		refresh(create_hints_from_mapping(selection_hints))
		return
	elif state_name == "TypeRaceTestState" || state_name == "TimeAttackTestState":
		refresh(create_hints_from_mapping(test_hints))
		return
	elif state_name == "EndTestState":
		refresh(create_hints_from_mapping(end_hints))
		return
	else:
		visible = false
#endregion
