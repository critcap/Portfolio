class_name SubentryTestArguments
extends SubentryBase
# Subentry for Typing Test arguments

var _base_data: Dictionary
var _combine: Array

onready var ToggleButton = load(
	"res://typewars/ListMenus/TestSelectionMenu/Subentry/toggle_button.gd"
)
onready var _mode: Button = $Body/Mode
onready var _size_label: Label = $Body/SizeLabel
onready var _size_input: SpinBox = $Body/SizeInput


# region Setters and Getters
func get_data() -> Dictionary:
	var data := {}
	data["combine"] = get_combine_values()
	data["mode"] = int(_mode.pressed)
	data["size"] = int(_size_input.value)
	return data


func get_combine_values() -> Array:
	var values = []
	if !_combine || _combine.empty():
		return values
	for i in _combine:
		if i.pressed:
			values.append(i.text)
	return values


# endregion


# region Public Methods
func setup(args: Dictionary) -> void:
	if args.has("combine") && args["combine"] is Array && !args["combine"].empty():
		_create_combine_buttons(args["combine"])
	_setup_mode_button(args["mode"] if args.has("mode") else PlayerManager.settings.args_base_mode)
	_setup_size_input(args["size"] if args.has("size") else PlayerManager.settings.args_base_size)

	get_node(first_born).set_focus_previous(_size_input.get_line_edit().get_path())
	get_node(first_born).focus_neighbour_left = _size_input.get_line_edit().get_path()
	_size_input.get_line_edit().set_focus_next(first_born)
	_size_input.get_line_edit().focus_neighbour_right = first_born


# endregion


# region Private Methods
func _create_combine_buttons(combines: Array) -> void:
	combines.invert()
	for index in combines:
		var button = ToggleButton.new()
		button.text = str(index)
		button.toggle_mode = true
		$Body.add_child_below_node($Body/CombineRoot, button, true)
		_combine.append(button)
		_combine.invert()
	first_born = _combine[0].get_path()


func _setup_mode_button(mode_text: int) -> void:
	_mode.text = TypingTestModes.mode_to_string(mode_text)
	_mode.set_pressed_no_signal(mode_text == TypingTestModes.RACE)
	if !first_born:
		first_born = _mode.get_path()


func _setup_size_input(size: int) -> void:
	_size_label.text = "Length:" if int(_mode.pressed) == 1 else "Time:"
	_size_input.value = size


func _unhandled_input(event):
	if !contains_focus():
		return
	if event is InputEventKey:
		var key_event = event as InputEventKey
		if key_event.is_action_pressed("ui_accept") && key_event.shift:
			on_ui_accept()


func on_ui_accept():
	owner.on_ui_accept()
	visible = false


func contains_focus() -> bool:
	if !visible:
		return false
	for child in $Body.get_children():
		if child is Control && child.has_focus():
			return true
	return false


# endregion


# region Callback Methods
func _on_mode_toggled(status: bool) -> void:
	_size_label.text = "Length:" if status else "Time:"

# endregion
