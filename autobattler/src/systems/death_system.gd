class_name DeathSystem
extends Node

func _ready() -> void:
	GlobalSignals.connect("check_for_death", self, "on_check_for_death")
	GlobalSignals.connect("perform_death_event", self, "on_perform_death_event")

func on_check_for_death(_event: GameEvent):
	for player in owner.players.values():
		for card in player.board_cards:
			if card.toughness <= 0:
				trigger_death(card)

func trigger_death(card: GameCard):
	var event = DeathEvent.new()
	event.card = card
	owner.get_node("EventSystem").add_reaction(event)

func on_perform_death_event(event: DeathEvent) -> void:
	var gy = Vector2.ZERO
	var card = event.card
	var player_view = owner.board.player_views[card.owner_index]
	var view = player_view.get_card_view(card)
	view.visible = false
	view.rest_point = gy
	view.global_position = gy
	owner.get_node("CardSystem").change_zone(card, Zones.GRAVEYARD)
	while view.global_position != gy:
		yield(get_tree(), "idle_frame")



	
