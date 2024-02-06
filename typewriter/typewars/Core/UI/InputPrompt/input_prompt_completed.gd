class_name InputPromptCompleted
extends HBoxContainer


func push(text: String) -> void:
	var label = Label.new()
	label.text = text

	if get_children().size() > 0:
		var first := get_children()[-1] as Label
		first.modulate = PlayerManager.settings.second_in_queue_color
	if get_children().size() > 1:
		var second := get_children()[-2] as Label
		second.visible = false

	label.modulate = PlayerManager.settings.first_in_queue_color
	visible = true
	add_child(label)


func reset() -> void:
	visible = false
	for child in get_children():
		remove_child(child)
		child.queue_free()
