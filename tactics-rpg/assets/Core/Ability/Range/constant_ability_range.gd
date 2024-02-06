class_name ConstantAbilityRange
extends AbilityRange

func get_tiles_in_range(board: Board) -> Array:
	var tiles = board.search_tiles(pawn.tile.position , funcref(self, "extended_search"))
	tiles.pop_front()

	return filter_minrange(tiles)
	
	
func extended_search(from: Tile, to: Tile) -> bool:
	if (
		(from.distance + 1) > horizontal
		|| abs(from.position.y - to.position.y) > vertical
	):
		return false
	return true
