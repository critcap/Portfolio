class_name Actor
extends Spatial

signal direction_changed(direction)

export(int, 0, 3) var direction: int setget set_direction, get_direction

var tile: Tile


func place(target: Tile) -> void:
	if !target:
		return
	if tile != null && tile.content == self:
		tile.content = null
	tile = target
	target.content = self


func set_direction(value: int):
	if direction == value:
		return
	direction = value
	emit_signal("direction_changed", direction)

	
func get_direction() -> int:
	return direction


func match_tile() -> void:
	translation = tile.translation
