class_name PlayerSystem
extends Node


func _ready():
	GlobalSignals.connect("perform_draw_event", self, "on_perform_draw_cards")


func on_perform_draw_cards(event: DrawCardsEvent) -> void:
	for _i in range(0, event.amount):
		var card = CardFactory.create_card()
		card.owner_index = event.player.index
		event.cards.append(card)
		owner.get_node("CardSystem").change_zone(card, Zones.HAND)


func draw_cards(player: PlayerBase, amount: int, viewable: bool = true) -> void:
	var event = DrawCardsEvent.new()
	var system = owner.get_node("EventSystem")
	
	event.player = player
	event.amount = amount
	event.viewable = viewable
	
	if system.is_active():
		system.add_reaction(event)
	else:
		system.perform(event)

func auto_perform_turn(player: PlayerBase) -> void:
	var enemy_view = owner.board.player_views[player.index]
	var field = enemy_view.field
	var CardView = preload("res://src/scenes/cards/CardView.tscn")
	var view_port = get_viewport().size
	for _c in player.hand_cards:
		_c.zone = Zones.FIELD
		var view = CardView.instance()
		view.visible = false
		
		view.global_position = Vector2(view_port.x/2, 0)
		view.rest_point = field.global_position
		owner.add_child(view)
		view.add_to_group(Groups.card_views)
		view.set_card(_c)
		
		view.owner = owner
		yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")


