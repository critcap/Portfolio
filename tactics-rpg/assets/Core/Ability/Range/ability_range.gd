class_name AbilityRange
extends Node


export(int, 0, 999) var min_horizontal: int
export(int, 0, 999) var horizontal: int

export(int, 0, 999) var min_vertical: int
export(int, 0, 999) var vertical: int

var pawn: Actor

var positional: bool setget , is_positional
var directional: bool setget , is_directional


func is_positional() -> bool:
	return true


func is_directional() -> bool:
	return false


func get_tiles_in_range(_board: Board) -> Array:
	return []


func filter_minrange(tiles: Array) -> Array:
	var output = []
	for tile in tiles:
		if tile.distance < min_horizontal:
			continue
		output.append(tile)
	return output
