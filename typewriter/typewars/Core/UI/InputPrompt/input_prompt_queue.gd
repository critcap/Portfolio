class_name InputPromptQueue
extends HBoxContainer


func add_queue(content: Array) -> void:
	for i in content:
		var label = Label.new()
		label.text = i
		add_child(label)
		label.visible = false
	refresh_queue()


func pop() -> Label:
	var children = get_children()
	if children.empty():
		return null
	var child = children[0]
	remove_child(child)
	refresh_queue()
	return child


func refresh_queue() -> void:
	var children = get_children()
	if children.size() == 0:
		return
	children[0].visible = true
	children[0].modulate = PlayerManager.settings.first_in_queue_color
	if !children.size() > 1:
		return
	children[1].visible = true
	children[1].modulate = PlayerManager.settings.second_in_queue_color


func reset() -> void:
	visible = false
	for child in get_children():
		remove_child(child)
		child.queue_free()
