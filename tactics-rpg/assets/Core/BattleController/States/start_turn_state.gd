class_name StartTurnState
extends BattleState

onready var turn_controller = owner.get_node("TurnController")


func enter():
	.enter()
	turn_controller.advance_turn()
	yield(get_tree(), "idle_frame")
	var stats = self.subject.get_node("Stats")

	stats.set_value(StatTypes.MVP, 1)
	stats.set_value(StatTypes.ATP, 1)

	var unit = owner.turn.subject.get_node("Pawn")
	owner.cursor.position = unit.tile.position
	yield(owner.camera_rig._jump_to_position(unit.translation, 0.5), "completed")

	if is_ai_turn():
		owner.turn.sequence = owner.cpu.evaluate()
	owner.change_state("SelectCommandState")
