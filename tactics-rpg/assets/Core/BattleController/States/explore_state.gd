class_name ExploreState
extends BattleState


func on_selection_accept() -> void:
	yield(get_tree(), "idle_frame")
	owner.change_state("SelectMovementState")
