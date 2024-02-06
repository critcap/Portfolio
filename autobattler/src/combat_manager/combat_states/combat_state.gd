class_name CombatState
extends State

var player: PlayerBase setget , get_player
var enemy: PlayerBase setget , get_enemy
var players: Array setget , get_players

func get_player() -> PlayerBase:
	return owner.players[PlayerIndex.PLAYER]

func get_enemy() -> PlayerBase:
	return owner.players[PlayerIndex.ENEMY]

func get_players() -> Array:
	return owner.players.values()

func get_opponent(_player: PlayerBase) -> PlayerBase:
	return self.players[1-_player.index]