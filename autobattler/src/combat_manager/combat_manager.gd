class_name CombatManager
extends StateMachine

var player: PlayerBase
var enemy: PlayerBase
var players: Dictionary
var turn: int
var gui: Node
var board: Node

var is_battle_over: bool

func start() -> void:
	change_state("InitCombatState")
	pass

func change_state(value: String) -> void:
	if !is_battle_over:
		.change_state(value)


