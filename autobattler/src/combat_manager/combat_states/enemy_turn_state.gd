class_name EnemyTurnState
extends CombatState

# * this is a placeholder state for the enemy trun
# * gamesettings
const CardView = preload("res://src/scenes/cards/CardView.tscn")

func _enter() -> void:
	._enter()
	play_cards()
	

func play_cards() -> void:
	yield(owner.get_node("PlayerSystem").auto_perform_turn(self.enemy), "completed")
	yield(get_tree(), "idle_frame")
	owner.change_state("BoardCombatState")
