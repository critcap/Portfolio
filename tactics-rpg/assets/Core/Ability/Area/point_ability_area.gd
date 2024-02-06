class_name PointAbilityArea
extends AbilityArea

func get_tiles_in_area(board: Board, pos: Vector3) -> Array:
	var output = []
	var area = board.get_tile(pos)
	if area != null:
		output.append(area)
	return output
