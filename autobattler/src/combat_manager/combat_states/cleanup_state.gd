class_name CleanupState
extends CombatState

func _enter() -> void:
	._enter()
	on_cleanup_step()

func on_cleanup_step() -> void:
	var EventSystem = owner.get_node("EventSystem")
	for player in self.players:
		var p_view = owner.board.player_views[player.index]
		var heal = DamageEvent.new()
		heal.amount = -99
		heal.targets = player.gravey_cards + player.board_cards
		EventSystem.perform(heal)
		#yield(EventSystem, "sequence_complete")

		for card in player.gravey_cards + player.board_cards:
			var view = p_view.get_card_view(card)
			if player.index == PlayerIndex.PLAYER:
				view.visible = true
			else:
				view.visible = false
			owner.get_node("CardSystem").change_zone(card, Zones.FIELD)
			view.rest_point = p_view.field.global_position
			view.rest_point.x += card.origin_zone_index
			view.global_position = view.rest_point	
		yield(get_tree(), "idle_frame")	
	
	owner.change_state("DrawCombatState")

			
