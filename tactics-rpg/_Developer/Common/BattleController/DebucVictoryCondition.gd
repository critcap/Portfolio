extends Node

func _gui(_delta) -> void:
	if owner.victory_condition == null:
		return
	GUI.label(owner.victory_condition.get_script().resource_path.get_file().replace(".gd", ""))
	GUI.label(str(
			"Victory Status: ",
			owner.current_state.is_battle_over()
	))