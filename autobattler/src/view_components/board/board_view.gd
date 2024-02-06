class_name BoardView
extends Node


var player_views: Dictionary setget , get_player_views

func get_player_views() -> Dictionary:
	return {PlayerIndex.PLAYER: $PlayerView, PlayerIndex.ENEMY: $EnemyView}


func setup(players: Array) -> void:
	for player in players:
		self.player_views[player.index].set_player(player)



	
