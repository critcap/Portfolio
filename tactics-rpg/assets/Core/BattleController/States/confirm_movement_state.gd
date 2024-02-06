class_name ConfirmMovementState
extends SelectMenuState

# TODO Config
const COMMANDS = ["Confirm", "Cancel"]
const SKIP_CONFIRM: bool = true


func enter() -> void:
	.enter()
	if SKIP_CONFIRM:
		yield(get_tree(), "idle_frame")
		move_to_perform_movement()
	else:
		owner.camera_rig._jump_to_position(self.command.destination.translation, 0.2)
		owner.cursor.position = self.command.destination.position
		menu.visible = true
		menu.get_items()[0].grab_focus()


func on_command_selected(response) -> void:
	match response:
		"Confirm":
			move_to_perform_movement()
		"Cancel":
			owner.change_state("SelectMovementState")


func move_to_perform_movement() -> void:
	self.board.deselect_tiles()
	owner.change_state("PerformMovementState")
