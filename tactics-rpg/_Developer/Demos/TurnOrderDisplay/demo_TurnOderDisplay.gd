extends Node

export(int, 16) var count: int = 0

const DEFAULT_COST = 64

var units := []
var wait_state


func _ready():
	for i in count:
		var unit = UnitFactory.create_unit()

		units.append(unit)
	units[-1].get_node("Stats").set_value(StatTypes.SPD, 32)
	$Control.setup(units)


func _gui(delta):
	for unit in units:
		GUI.hbox()
		var wait = unit.get_node("Stats").get_value(StatTypes.WAIT)
		var speed = unit.get_node("Stats").get_value(StatTypes.SPD)
		GUI.label(str(unit.name, " ", speed, " ", wait))

		if $Control.register.has(unit):
			if GUI.button("remove"):
				$Control.remove(unit)
		else:
			if GUI.button("add"):
				$Control.add(unit)
		GUI.end()

	if GUI.button("Advance Turn"):
		if !wait_state:
			wait_state = advance_wait()
		else:
			wait_state = wait_state.resume()


func advance_wait() -> void:
	while true:
		for unit in units:
			if !unit.has_node("Stats"):
				return

			var stats = unit.get_node("Stats")
			# decrements but could also be incremental, bound to change
			var spd = stats.get_value(StatTypes.SPD)
			var wait = stats.get_value(StatTypes.WAIT)
			stats.set_value(StatTypes.WAIT, wait - spd)

		units.sort_custom(TurnController, "sort_wait_time")

		for battler in units:
			if battler.get_node("Stats").get_value(StatTypes.WAIT) <= 0:
				yield()
				battler.get_node("Stats").set_value(StatTypes.WAIT, DEFAULT_COST)
				print(battler.name + " takes turn")
				$Control.refresh(units.duplicate())
