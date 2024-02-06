class_name Faction
extends Node

var type: int
var is_confused: bool = false
 

func is_match(other: Faction, targets: int) -> bool:
	var is_match: = false

	match targets:
		Targets.SELF:
			is_match = other == self

		Targets.ALLY:
			is_match = type == other.typ
			
		Targets.ENEMY:
			is_match = (type != other.type) && other.type != Factions.NEUTRAL

	return is_match if !is_confused else !is_match
