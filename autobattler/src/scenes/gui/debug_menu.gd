extends Control

export (NodePath) var gm_path

onready var win_game: = $VBoxContainer/HBoxContainer/Button


func on_debug_process_victory() -> void:
	var state_machine = get_node(gm_path)
	state_machine.enemy.toughness = -1
	if state_machine:
		state_machine.change_state("MatchEndState")

func on_debug_process_defeat() -> void:
	var state_machine = get_node(gm_path)
	state_machine.player.toughness = -1
	if state_machine:
		state_machine.change_state("MatchEndState")

