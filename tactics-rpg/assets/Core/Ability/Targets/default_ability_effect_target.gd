class_name DefaultAbilityEffectTarget
extends AbilityEffectTarget


func is_valid_target(target: Tile) -> bool:
	var pawn = target.content
	if target == null || target.content == null:
		return false

	var battler = pawn.owner
	var health = battler.get_node("Health") as Health
	return health != null && health.current > 0
