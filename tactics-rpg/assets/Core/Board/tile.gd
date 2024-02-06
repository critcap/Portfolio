class_name Tile
extends Node

var id: int setget , get_id

# position in board space
var position: Vector3
# postion in world space
var translation: Vector3

var content: Node

# pathfinding
var distance: int
var previous: Tile


# terrain
var terrain: int = Terrain.GROUND


func get_id() -> int:
	return hash(position)
