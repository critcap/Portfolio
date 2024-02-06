class_name BaseAbilityEffect
extends Node

signal effect_hit(target, value)
signal effect_missed(target)


func predict(_target: Tile) -> int:
	return 0


func apply(target: Tile) -> void:
	if !get_effect_target().is_valid_target(target):
		return

	if get_hit_rate().roll_for_hit(target):
		emit_signal("effect_hit", target, on_apply(target))
	else:
		emit_signal("effect_missed", target)


func on_apply(_target: Tile) -> int:
	return 0


func get_hit_rate() -> HitRate:
	for c in get_children():
		if c is HitRate:
			return c
	return null


func get_effect_target() -> AbilityEffectTarget:
	for c in get_children():
		if c is AbilityEffectTarget:
			return c
			
	add_child(DefaultAbilityEffectTarget.new())	
	return get_effect_target()
