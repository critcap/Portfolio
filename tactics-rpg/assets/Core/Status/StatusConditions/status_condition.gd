class_name StatusCondition
extends Node

func remove() -> void:
	var status = owner.get_node("Status")

	if status:
		status.remove(self)