class_name SelectMovementState
extends BattleState

var manual: bool

func enter() -> void:
	.enter()
	
	self.command.mover = self.subject.get_node("Movement") as WalkMovement
	var pathfinding = self.command.mover.get_tiles_in_range(self.board)
	owner.board.select_tiles(pathfinding)
	
	if is_ai_turn():
		owner.cursor.position = self.turn.sequence.move_location.position
		yield(get_tree().create_timer(.5), "timeout")
		self.command.destination = self.turn.sequence.move_location
		if !manual:
			owner.change_state("ConfirmMovementState")
	

func on_accept() -> void:
	if self.tile.previous:
		if !self.command.destination: 
			self.command.destination = self.tile
		owner.change_state("ConfirmMovementState")

	else:
		# TODO remove before deploy
		print("oob")


func on_cancel() -> void:
	yield(get_tree(), "idle_frame")
	self.board.deselect_tiles()
	owner.change_state("SelectCommandState")
