class_name DefeatTargetVictoryCondition
extends BaseVictoryCondition

var target: Node


func check_for_gameover() -> void:
	.check_for_gameover()
	if _victor == Factions.NONE && is_defeated(target):
		self.victor = Factions.HERO