class_name DefeatAllEnemiesVictoryCondition
extends BaseVictoryCondition


func check_for_gameover() -> void:
	.check_for_gameover()

	if _victor == Factions.NONE && party_is_defeated(Factions.ENEMY):
		self.victor = Factions.HERO
