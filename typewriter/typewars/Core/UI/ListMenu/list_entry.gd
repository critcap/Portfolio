class_name ListEntry
extends HBoxContainer

# emits when pressed and also passes the item's subentry data along if available
signal pressed(subentry_data)

# TODO add assginent in list_menu
var subentry: SubentryBase

onready var indicator: Label = $IndicatorSelect
onready var selector: Label = $IndicatorSubEntry
onready var invalidator: Label = $IndicatorInvalid
onready var item: Control = $Item


func setup(name: String, subentry_args: Dictionary = {}) -> void:
	item.text = name
	if has_subentry():
		subentry.setup(subentry_args)


func select_item():
	item.visible = true
	prefix(0)
	if !item.has_focus():
		item.grab_focus()


func deselect_item():
	if item.has_focus():
		item.release_focus()
	prefix()


func _on_item_pressed():
	if !Input.is_key_pressed(KEY_SHIFT):
		on_ui_accept()
		return
	if !has_subentry():
		prefix(2)
		return
	if subentry.visible:
		return
	subentry.visible = true
	subentry.select_item()
	prefix(1)


func has_subentry() -> bool:
	if subentry:
		return true
	# searches childs for subentry node and caches it when found
	for child in get_children():
		if child is SubentryBase:
			subentry = child
			return true
	return false


func prefix(index: int = -1) -> void:
	var prefixes = [indicator, selector, invalidator]
	for i in prefixes:
		i.visible = false
	if index > prefixes.size() || index < 0:
		return
	prefixes[index].visible = true


func on_ui_accept() -> void:
	emit_signal("pressed", subentry.data)
	prefix(0)
	if has_subentry():
		subentry.visible = false
