class_name SubentryBase
extends AspectRatioContainer

# first node to grab focus on show
export(NodePath) var first_born: NodePath
# Is not typed because different types of subentries have different types of data
var data setget set_data, get_data

onready var is_static: bool = first_born != null


# region Setters & Getters
func set_data(_new_data):
	pass


func get_data():
	pass


# endregion


# region Methods
func setup(_args) -> void:
	pass


func select_item():
	var item = get_node(first_born)
	visible = true
	if item == null:
		return
	item.grab_focus()


func deselect_item():
	if !visible:
		return
	visible = false
	if owner:
		owner.select_item()
		get_tree().set_input_as_handled()


# endregion


# region Private Methods
func _unhandled_input(event):
	if !contains_focus():
		return
	if !is_static:
		return
	if event.is_action_pressed("ui_cancel"):
		deselect_item()
	return


func contains_focus() -> bool:
	return has_focus()
# endregion
