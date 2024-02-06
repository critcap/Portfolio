class_name DrawCardsView
extends Node

func _ready() -> void:
	GlobalSignals.connect("prepare_draw_event", self, "on_prepare_draw_event")


func on_prepare_draw_event(event: DrawCardsEvent) -> void:
	if event.viewable:
		event.perform.viewer = funcref(self, "DrawCardsViewer")

func DrawCardsViewer(event: DrawCardsEvent, handler: FuncRef) -> void:
	handler.call_func()
	yield(get_tree(), "idle_frame")
	var player_view = owner.board.player_views[event.player.index]
	var spawn = player_view.hand
	var CardView = preload("res://src/scenes/cards/CardView.tscn")
	for card in event.cards:
		var card_view = CardView.instance()
		owner.add_child(card_view)
		card_view.set_card(card)
		card_view.rest_point = spawn.global_position
		card_view.global_position = get_viewport().size
		card_view.owner = owner
		card_view.add_to_group(Groups.card_views)
		while card_view.zone_index == null:
			yield(get_tree(), "idle_frame")
	return true
