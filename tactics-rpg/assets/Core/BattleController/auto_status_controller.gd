class_name AutoStatusController
extends Node


func _ready():
	Notifications.subscribe(Health.HP_CHANGE_NOTIFICATION , self, funcref(self, "on_current_hp_changed"))


func on_current_hp_changed(args) -> void:
	var health: = args as Health

	if health.current <= health.minhp:
		var effect = KnockOutStatusEffect.new(health)
		var condition = StatComparisonCondition.new(health.owner.get_node("Stats"), \
													StatTypes.HP, \
													health.minhp
													)
		condition.operator = funcref(condition, "equal_to")
		health.owner.get_node("Status").add(effect, condition)
