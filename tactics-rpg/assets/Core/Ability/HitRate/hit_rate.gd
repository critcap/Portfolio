class_name HitRate
extends Node


func roll_for_hit(target: Tile) -> bool:
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var roll: = rng.randi_range(0, 101) as int
	var chance: = calculate(target)

	return roll <= chance


func calculate(target: Tile) -> int:
	
	var evasion = target.content.owner.get_node("Stats").get_value(StatTypes.EVA)
	return 100 - evasion
