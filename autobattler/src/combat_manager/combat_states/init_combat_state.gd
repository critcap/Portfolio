class_name InitCombatState
extends CombatState

# * Gamesettings
const DEFAULT_HEALTH: int = 30
var DEFAULT_HAND_SIZE: int = 3


func _enter() -> void:
	._enter()
	init_members()


func init_members() -> void:	
	init_players()
	owner.board.setup(self.players)
	yield(owner.get_node("AnnouncerView").Announce("Defeat your", " Opponent!"), "completed")
	enemy_draw_cards()
	while owner.get_node("EventSystem").is_active():
		yield(get_tree(), "idle_frame")
	player_draw_cards()
	while owner.get_node("EventSystem").is_active():
		yield(get_tree(), "idle_frame")

	yield(get_tree(), "idle_frame")

	owner.turn = 0
	owner.change_state("DrawCombatState")


func player_draw_cards() -> void:
	owner.get_node("PlayerSystem").draw_cards(self.player, DEFAULT_HAND_SIZE)

func enemy_draw_cards() -> void:
	owner.get_node("PlayerSystem").draw_cards(self.enemy, DEFAULT_HAND_SIZE, false)


func init_players() -> void:
	for p in self.players:
		p.max_toughness = DEFAULT_HEALTH
		p.toughness = p.max_toughness		
		p.index = self.players.find(p)




