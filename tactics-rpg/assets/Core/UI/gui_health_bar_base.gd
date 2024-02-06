class_name HealthBar
extends ProgressBar


func init() -> void:
	step = 1.0


func setup(_health: Health) -> void:
	max_value = _health.maxhp
	min_value = _health.minhp
	value = _health.current

	_health.connect("current_hp_changed", self, "on_current_hp_change")
	_health.connect("max_hp_changed", self, "on_max_hp_change")


func on_current_hp_change(new_hp: int) -> void:
	value = new_hp


func on_max_hp_change(new_mhp: int) -> void:
	max_value = new_mhp
