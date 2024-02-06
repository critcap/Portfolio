class_name Ability
extends Node

const MESSAGE_HIT = "%s deals %s damage to %s!"
const MESSAGE_MISS = "%s evades %s attack!"

signal perform_completed

var subject: Node

var ability_range: AbilityRange setget , get_range
var area: AbilityArea setget , get_area


#region setters getters
func get_range():
	if ability_range:
		return ability_range

	for i in get_children():
		if i is AbilityRange:
			ability_range = i
			return i


func get_area():
	if area:
		return area
	for i in get_children():
		if i is AbilityArea:
			area = i
			return i


#endregion


func perform(targets: Array) -> void:
	var projectile = get_projectile_skill()
	if projectile:
		var collider = projectile.trajectory.collider
		if collider.owner == null || !(collider.owner is Actor):
			on_miss(targets[0])
			emit_signal("perform_completed")
			return
		var pawn: = collider.owner as Actor
		targets = [pawn.tile]

	for target in targets:
		for effect in $Effects.get_children():
			effect.apply(target)

	emit_signal("perform_completed")


func on_hit(target, value) -> void:
	print(MESSAGE_HIT % [subject.name, value, target.content.owner.name])


func on_miss(target) -> void:
	print(MESSAGE_MISS % [target.content.owner.name, subject.name])


func get_projectile_skill() -> Node:
	for c in get_children():
		if c is Projectile:
			return c
	return null
