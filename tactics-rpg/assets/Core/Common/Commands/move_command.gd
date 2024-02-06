class_name MoveCommand
extends Command

var destination: Tile
var mover: Movement setget set_mover

var _origin: Tile
var _direction: int


func set_mover(value: Movement) -> void:
	mover = value
	_origin = mover.unit.tile
	_direction = mover.unit.direction


func execute(shortcut := false) -> void:
	.execute()

	if shortcut:
		# TODO add shortcut code
		pass
	var mvp = mover.owner.get_node("Stats").get_value(StatTypes.MVP)
	mover.owner.get_node("Stats").set_value(StatTypes.MVP, mvp - 1)
	mover.traverse(destination)


func undo() -> void:
	.undo()

	var mvp = mover.owner.get_node("Stats").get_value(StatTypes.MVP)
	mover.owner.get_node("Stats").set_value(StatTypes.MVP, mvp + 1)

	mover.unit.place(_origin)
	mover.unit.direction = _direction
	mover.unit.match_tile()
