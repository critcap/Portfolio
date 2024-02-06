class_name AbilityInventory
extends Node


var _register: Dictionary


func get_ability(_name: String):
	if !_register.has(_name):
		return null
	return _register[_name]


func get_all_abilities() -> Array:
	return _register.values()


func add_ability(ability: Ability) -> void:
	if _register.has(ability.name):
		push_warning("Already know this Ability")
		return
	
	_register[ability.name] = ability
	add_child(ability)
