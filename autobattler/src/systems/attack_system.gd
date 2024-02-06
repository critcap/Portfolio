class_name AttackSystem
extends Node

func _ready() -> void:
	GlobalSignals.connect("perform_attack_event", self, "on_perform_attack_event")

func on_perform_attack_event(event: AttackEvent) -> void:
	event.attacker.remaining_attacks -= 1
	apply_attack_damage(event)
	if event.target is GameCard:
		apply_counter_attack_damage(event)


func apply_attack_damage(event: AttackEvent) -> void:
	var damage_event = DamageEvent.new()
	damage_event.amount = event.attacker.power
	damage_event.add_target(event.target)
	damage_event.viewable = true
	owner.get_node("EventSystem").add_reaction(damage_event)

func apply_counter_attack_damage(event: AttackEvent) -> void:
	var damage_event = DamageEvent.new()
	damage_event.amount = event.target.power
	damage_event.add_target(event.attacker)
	damage_event.viewable = true
	owner.get_node("EventSystem").add_reaction(damage_event)
