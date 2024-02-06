extends Control

const UnitContainer := preload("res://assets/SceneBattle/TurnOrderDisplay/UnitContainer.tscn")

var register := {}


func setup(units: Array) -> void:
	units.sort_custom(self, "sort_predict_wait")
	for unit in units:
		add(unit)


func refresh(units: Array) -> void:
	units.sort_custom(self, "sort_predict_wait")
	for i in $Body.get_children():
		$Body.remove_child(i)
	for u in units:
		if !register.has(u):
			continue
		$Body.add_child(register[u])


func add(unit) -> void:
	if register.has(unit):
		return
	var container = UnitContainer.instance()
	$Body.add_child(container)
	container.setup(unit)
	register[unit] = container


func remove(unit) -> void:
	if !register.has(unit):
		return
	var frame = register[unit]
	register.erase(unit)
	$Body.remove_child(frame)
	frame.queue_free()


func sort_predict_wait(a, b) -> bool:
	if get_predicted_wait_counter(a) < get_predicted_wait_counter(b):
		return true
	return false


func get_predicted_wait_counter(unit) -> int:
	if !unit.get_node("Health").is_alive():
		return 9999
	var stats = unit.get_node("Stats")
	return stats.get_value(StatTypes.WAIT) / stats.get_value(StatTypes.SPD)
