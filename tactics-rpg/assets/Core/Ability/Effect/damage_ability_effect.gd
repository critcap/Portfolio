class_name DamageAbilityEffect
extends BaseAbilityEffect

enum stat_types {
	JUMP = 1,
	HP = 2,
	MHP = 3,
	SPD = 5,
	ATK = 6,
	DEF = 7,
	ATP = 10,
	MVP = 11,
}

export(int, 0, 999) var base: int
export(float, 0.0, 100.0) var stat_modifier_scale: float
export(stat_types) var stat_modifier


func predict(target: Tile) -> int:
	var attacker = owner.subject
	var defender := target.content.owner

	var attack: float = attacker.get_node("Stats").get_value(stat_modifier) * stat_modifier_scale
	attack += base if base > 0 else attacker.get_node("Stats").get_value(StatTypes.ATK)

	var defense: int = defender.get_node("Stats").get_value(StatTypes.DEF)

	var damage: float = attack - (defense / 2.0)
	damage = clamp(damage, -999, 999)

	return -int(damage)


func on_apply(target: Tile) -> int:
	var value = predict(target)

	var battler: Node = target.content.owner
	var health = battler.get_node("Health") as Health

	health.current += value

	return value
