class_name BaseView
extends Node

func get_view_component(entity):
	var board = owner.board
	if entity is PlayerBase:
		return board.player_views[entity.index].avatar.hit_target
	elif entity is GameCard:
		return board.player_views[entity.owner_index].get_card_view(entity)
