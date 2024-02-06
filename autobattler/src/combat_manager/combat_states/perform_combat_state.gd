class_name PerformCombatState
extends CombatState

const DEFAULT_ATTACKS: int = 1
var random: RandomNumberGenerator


func _enter() -> void:
	._enter()
	# * init vards
	yield(owner.get_node("AnnouncerView").Announce("Battle", "Start"), "completed")
	on_perform_combat()

func on_perform_combat() -> void:
	random = RandomNumberGenerator.new()
	random.seed = int(OS.get_unix_time() * PI)
	random.randomize()
	yield(perform_minion_combat(), "completed")

	if self.player.board_cards.size() > 0:
		yield(perform_player_combat(self.player, self.enemy), "completed")
	elif self.enemy.board_cards.size() > 0:
		yield(perform_player_combat(self.enemy, self.player), "completed")
	
	owner.change_state("CleanupState")

func perform_minion_combat():
	var si = random.randi_range(0,1)
	while self.player.board_cards.size() > 0 && self.enemy.board_cards.size() > 0:
		for player in [self.players[si], self.players[1 - si]]:
			if player.board_cards.size() <= 0:
				break
			var opponent = get_opponent(player)	
			if !get_random_target_from_player(opponent):
				break
			if !get_valid_attacker_from_player(player):
				for card in player.board_cards:
					card.remaining_attacks = DEFAULT_ATTACKS			
			var attacker = get_valid_attacker_from_player(player)
			var target = get_random_target_from_player(opponent)
			yield(perform_damage_event(attacker, target), "completed")

func perform_player_combat(winner: PlayerBase, loser: PlayerBase) -> void:
	var attackers = winner.board_cards.duplicate()
	attackers.sort_custom(self, "sort_for_positions")
	for card in attackers:
		card.remaining_attacks = DEFAULT_ATTACKS
		yield(perform_damage_event(card, loser), "completed")


func perform_damage_event(attacker, target) -> void:
	var EventSystem = owner.get_node("EventSystem")
	var event = AttackEvent.new()
	event.attacker = attacker
	event.target = target
	EventSystem.perform(event)
	yield(EventSystem, "sequence_complete")



func get_valid_attacker_from_player(player: PlayerBase): 
	var board = player.board_cards.duplicate()
	board.sort_custom(self, "sort_for_positions")
	if board.size() == 0:
		return 
	for card in board:
		if card.remaining_attacks > 0:
			return card
	return 

func get_random_target_from_player(player: PlayerBase):
	if player.board_cards.size() <= 0:
		return 
	random.randomize()
	var index = random.randi_range(0, player.board_cards.size() -1)
	return player.board_cards[index]



static func sort_for_positions(a,b):
	if a.zone_index < b.zone_index:
		return true
	return false	 
