extends Node


func get_command_name(command: Command) -> String:
	if command:
		return command.get_script().resource_path.get_file().replace(".gd", "")
	return ""


func _gui(_delta):
	if owner.current_state:
		GUI.label(owner.current_state.is_ai_turn())
		GUI.label(owner.subject.get_node("Driver").current)
	GUI.label("COMMAND HISTORY")

	if owner.turn:
		GUI.label(str("Index: ", owner.turn.index))

		if owner.turn.stack.size() > 0:
			var stack = owner.turn.stack

			for command in stack:
				if command == null:
					return
				command = command

				GUI.hbox()
				var position: int = stack.find(command)
				var name := get_command_name(command)

				GUI.label(str(position, ". ", name))


				if position == owner.turn.index:
					if GUI.button("Undo"):
						owner.turn.undo()
				GUI.end()
