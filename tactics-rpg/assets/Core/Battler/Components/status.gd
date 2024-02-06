class_name Status
extends Node


signal status_added(effect)
signal status_removed(effect)


func add(effect: StatusEffect, condition: StatusCondition) -> void:
	if check_if_status_already_exist(effect):
		return

	effect.add_child(condition)
	add_child(effect)
	effect.owner = self.owner
	condition.owner = effect.owner
	emit_signal("status_added", effect)


func remove(condition: StatusCondition) -> void:
	var effect = condition.get_parent()
	emit_signal("status_removed", effect)
	effect.queue_free()


func check_if_status_already_exist(effect) -> bool:
	if get_children().empty():
		return false
	for child in get_children():
		if child.get_script().resource_path.get_file() == effect.get_script().resource_path.get_file():
			return true
	return false
