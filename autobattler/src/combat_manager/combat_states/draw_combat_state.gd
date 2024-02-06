class_name DrawCombatState
extends CombatState

# * Gamesettings
const STARTING_HANDSIZE: int = 5
const CardView = preload("res://src/scenes/cards/CardView.tscn")

func _enter() -> void:
	._enter()
	owner.turn += 1
	var turn_count = " " + Int2Word.to_word(owner.turn)
	yield(owner.get_node("AnnouncerView").Announce("Turn", turn_count), "completed")
	on_draw_step()


func on_draw_step() -> void:
	var event_system = owner.get_node("EventSystem")
	var player_system = owner.get_node("PlayerSystem")
	player_system.draw_cards(self.player, 1)
	yield(event_system, "sequence_complete")
	player_system.draw_cards(self.enemy, 1, false)
	while owner.get_node("EventSystem").is_active():
		yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	owner.change_state("EnemyTurnState")
	



