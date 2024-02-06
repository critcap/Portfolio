class_name CircleAbilityArea
extends AbilityArea


export(int,0, 999) var horizontal: int
export(int,0, 999) var vertical: int

var tile: Tile


func get_tiles_in_area(board: Board, pos: Vector3):
	tile = board.get_tile(pos)

	if !tile is Tile:
		return []
	
	return board.search_tiles(tile.position, funcref(self, "extended_search"))

	
func extended_search(from: Tile, to: Tile) -> bool:
	if (
		(from.distance + 1) > horizontal
		|| abs(from.position.y - to.position.y) > vertical
	):
		return false
	return true
