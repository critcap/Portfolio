class_name DamageSystem
extends Node

func _ready() -> void:
	GlobalSignals.connect("perform_damage_event", self, "on_perform_damage_event")

func on_perform_damage_event(event: DamageEvent) -> void:
	if !event.targets || event.targets.size() < 1:
		return
	for target in event.targets:
		target.toughness -= event.amount
		if target is GameCard:
			target.toughness = min(target.toughness, target.data.toughness)


