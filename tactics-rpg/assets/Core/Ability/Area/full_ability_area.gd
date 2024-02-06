class_name FullAbilityArea
extends AbilityArea

func get_tiles_in_area(board: Board, _pos: Vector3) -> Array:
	var _range: = get_parent().ability_range as AbilityRange
	return _range.get_tiles_in_range(board)
