extends Control

var units: Array


func _gui(delta):
	if !units.empty():
		for unit in units:
			var hp = unit.get_node("Health")
			var stats := unit.get_node("Stats") as Stats
			var _owner = (
				unit.get_node("Pawn").tile.content.owner.name
				if unit.get_node("Pawn").tile.content != null
				else null
			)
			GUI.label(
				str(
					unit.name,
					" | HP: ",
					hp.current,
					"/",
					hp.maxhp,
					", ",
					stats.get_value(StatTypes.ATP),
					", ",
					stats.get_value(StatTypes.MVP),
					unit.get_node("Pawn").tile.position
				)
			)
			if unit.get_node("Status").get_children().empty():
				continue
			GUI.label(str(
					"Status: ",
					unit.get_node("Status").get_children()
			))
