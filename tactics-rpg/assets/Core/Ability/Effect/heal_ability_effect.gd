class_name HealAbilityEffect
extends BaseAbilityEffect

export (int, 0, 999) var base: int


func predict(_target: Tile) -> int:
	return base


func on_apply(target: Tile) -> int:
	var def_health = target.content.owner.get_node("Health")

	var value = predict(target)

	value = clamp(value, 0, 999)

	def_health.current += value
	return value
