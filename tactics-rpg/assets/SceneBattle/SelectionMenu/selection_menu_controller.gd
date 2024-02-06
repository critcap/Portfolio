class_name SelectionMenuController
extends Control

signal item_selected(item)


var _items: Array
var _keymap: Dictionary


func _unhandled_input(event) -> void:
	if !visible && _items:
		return
	if event is InputEventKey:
		if event.scancode == KEY_1:
			on_button_pressed(0)
		elif event.scancode == KEY_2:
			on_button_pressed(1)
		elif event.scancode == KEY_3:
			on_button_pressed(2)
		elif event.scancode == KEY_4:
			on_button_pressed(3)
		elif event.scancode == KEY_5:
			on_button_pressed(4)
		elif event.scancode == KEY_6:
			on_button_pressed(5)
		elif event.scancode == KEY_7:
			on_button_pressed(6)
		elif event.scancode == KEY_8:
			on_button_pressed(7)
		elif event.scancode == KEY_9:
			on_button_pressed(8)
		elif event.scancode == KEY_0:
			on_button_pressed(9)


func create_menu_list(list: Array) -> void:
	clear()
	var body = $VBoxContainer
	_items = []
	for item in list:
		item = item as String
		var button = Button.new()
		button.text = item
		_items.append(button.text)
		body.add_child(button)
		button.owner = self
		button.connect("pressed", self, "on_button_pressed", [list.find(item)])


func open(position: Vector2 = Vector2.ZERO) -> void:
	rect_position = position
	visible = true
	$VBoxContainer.get_children()[0].grab_focus()


func close() -> void:
	var focus_owner = get_focus_owner()

	if focus_owner && focus_owner.get_parent() == $VBoxContainer:
		focus_owner.release_focus()
		
	visible = false


func clear() -> void:
	for child in $VBoxContainer.get_children():
		child.queue_free()


func on_button_pressed(item_index: int) -> void:
	if item_index >= _items.size():
		return
	emit_signal("item_selected", _items[item_index])
