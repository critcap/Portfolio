class_name PrepareCombatState
extends CombatState



func _enter() -> void:
	._enter()
	on_prepare_combat()

func on_prepare_combat() -> void:

	var all_board_cards = self.player.board_cards + self.enemy.board_cards
	for card in all_board_cards:
		card.origin_zone_index = card.origin_zone_index
		card.remaining_attacks = 1

	for view in get_tree().get_nodes_in_group(Groups.card_views):
		if view.card.zone == Zones.FIELD :
			view.visible = true
	yield(get_tree().create_timer(0.5), "timeout")
	
	owner.change_state("PerformCombatState")
	# for card in self.player.board_cards:
	# 	var attack_event = AttackEvent.new()
	# 	attack_event.attacker = card
	# 	var rng = RandomNumberGenerator.new()
	# 	rng.randomize()
	# 	attack_event.target = self.enemy.board_cards[rng.randi_range(0,5)]
	# 	owner.get_node("EventSystem").perform(attack_event)         
	# 	yield(owner.get_node("EventSystem"), "sequence_complete")
	# 	# while owner.get_node("EventSystem").is_active():
	# 	# 	yield(get_tree(), "idle_frame")
	
		
