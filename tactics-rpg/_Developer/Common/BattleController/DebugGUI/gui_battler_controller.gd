extends Node

var auto_select: bool setget set_auto_select

func set_auto_select(value: bool) -> void:
	owner.get_node("SelectMovementState").manual = value
	auto_select = value

func _gui(_delta) -> void:
	self.auto_select = GUI.toggle("Manual Movement Select", auto_select)
	if GUI.button("continue"):
		if auto_select && owner.current_state is SelectMovementState:
			owner.current_state.on_accept()
