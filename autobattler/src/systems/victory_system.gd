class_name VictorySystem
extends Node


func _ready() -> void:
	owner.get_node("EventSystem").connect("sequence_ended", self, "check_game_state")


func check_game_state(_event) -> void:
	for player in owner.players.values():
		if player.toughness <= 0:
			owner.change_state("MatchEndState")
			owner.is_battle_over = true

