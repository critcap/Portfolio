class_name Movement
extends Node

signal traverse_finished

var move_range: int
var jump: int

var unit: Actor


func get_tiles_in_range(map: Board) -> Dictionary:
	var stats = owner.get_node("Stats")
	move_range = stats.get_value(StatTypes.MOVE)
	jump = stats.get_value(StatTypes.JUMP)

	var tiles = map.search_tiles(unit.tile.position, funcref(self, "extended_search"))
	filter(tiles)
	return tiles


func extended_search(_from: Tile, _to: Tile) -> bool:
	return _from.distance + 1 <= move_range


func filter(_tile_list) -> void:
	pass


func traverse(_tile: Tile) -> void:
	emit_signal("traverse_finished")


func turn(to: Tile) -> void:
	var difference: Vector3 = to.position - unit.tile.position
	difference.y = 0.0
	match difference.normalized():
		Vector3.FORWARD:
			unit.direction = 2
		Vector3.RIGHT:
			unit.direction = 1
		Vector3.BACK:
			unit.direction = 0
		Vector3.LEFT:
			unit.direction = 3
