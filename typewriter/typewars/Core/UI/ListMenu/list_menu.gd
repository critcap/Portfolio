class_name ListMenu
extends VBoxContainer

signal item_selected(index, subentry)

export(PackedScene) var Entry: PackedScene


func setup(_input) -> void:
	pass


func create_entry(value) -> void:
	var entry := Entry.instance() as ListEntry
	add_child(entry)
	entry.setup(str(value))


func create_focus_wrapping() -> void:
	var children := get_children()
	if children.empty() || children.size() == 1:
		return

	var first := children[0].item as Button
	var last := children[-1].item as Button
	first.set_focus_neighbour(margin_top, last.get_path())
	last.set_focus_neighbour(margin_bottom, first.get_path())


func on_item_pressed(subentry: Dictionary, item_index: int) -> void:
	if !visible:
		return
	emit_signal("item_selected", item_index, subentry)


func open() -> void:
	visible = true
	if get_children().empty():
		return
	get_children()[0].select_item()


func clear() -> void:
	if get_children().size() == 0:
		return

	for child in get_children():
		remove_child(child)
		child.free()
