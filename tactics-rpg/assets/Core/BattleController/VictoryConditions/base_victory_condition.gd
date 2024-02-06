class_name BaseVictoryCondition
extends Node


var _victor: int = Factions.NONE
var victor: int setget set_victor, get_victor

func set_victor(value: int) -> void:
	_victor = value

func get_victor() -> int:
	return _victor


func setup() -> void:
	for unit in owner.units:
		unit.get_node("Health").connect("current_hp_changed", self, "on_hp_did_change_signal")


func on_hp_did_change_signal(_value: int) -> void:
	check_for_gameover()


func check_for_gameover() -> void:
	if party_is_defeated(Factions.HERO):
		self.victor = Factions.ENEMY


func party_is_defeated(faction: int) -> bool:
	for unit in owner.units:
		var unit_faction: = unit.get_node("Faction") as Faction

		if !unit_faction:
			continue 

		if unit_faction.type == faction && !is_defeated(unit):
			return false
	return true



func is_defeated(unit: Node) -> bool:
	var health: = unit.get_node("Health") as Health
	
	if health:
		return health.minhp >= health.current
	
	var stats: = unit.get_node("Stats") as Stats
	return stats.get_value(StatTypes.HP) == 0
