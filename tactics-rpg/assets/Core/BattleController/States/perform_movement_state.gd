class_name PerformMovementState
extends BattleState

const _SPEED := 0.25


func enter() -> void:
	.enter()

	var destination = self.command.destination
	# TODO should follow the unit instead of jumping to the destination
	self.camera_rig._jump_to_position(destination.translation, 0.2)
	owner.cursor.locked = true
	owner.cursor.position = destination.position
	self.camera_rig.freeze_camera()
	perform_Movement()


func perform_Movement() -> void:
	var mover = self.command.mover
	mover.animation_speed = _SPEED
	mover.connect("traverse_finished", self, "on_traverser_finished")
	self.command.execute()


func on_traverser_finished() -> void:
	owner.cursor.locked = false
	self.camera_rig.release_camera()
	if is_battle_over():
		process_battle_end()
		return
	owner.change_state("SelectCommandState")
