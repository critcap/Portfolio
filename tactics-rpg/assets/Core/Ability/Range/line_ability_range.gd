class_name LineAbilityRange
extends AbilityRange


func is_directional() -> bool:
	return true


func get_tiles_in_range(board: Board) -> Array:
	var output: = []
	for h in range(1, horizontal + 1):
		var dir = Directions.dir_to_vec3(pawn.direction)
		var tiles = board.get_pf_tiles(pawn.tile.position + dir * h)

		for tile in tiles:
			if abs(tile.position.y - pawn.tile.position.y) <= vertical:
				tile.distance = h
				output.append(tile)
	
	return filter_minrange(output)
