class_name BoardGenerator
extends Object


static func generate_board(size: Vector2, tile_size: Vector2 = Vector2(1, 1)) -> Dictionary:
	var output = {}
	for x in range(size.x * -1, size.x + 1, 1):
		for y in range(size.y * -1, size.y + 1, 1):
			var tile = Tile.new()
			tile.position = Vector3(x, 0, y)
			tile.translation = tile.position * Vector3(tile_size.x, 0, tile_size.y)
			tile.previous = null
			tile.distance = 999
			output[tile.position] = tile
	return output


static func generate_from_raw(raw_data: Dictionary) -> Dictionary:
	var output = {}
	for r_tile in raw_data.values():
		if !r_tile.has("position") || !r_tile.has("translation"):
			continue
		if r_tile.position.y > 20:
			continue	
		var tile = Tile.new()
		tile.position = r_tile.position
		tile.translation = r_tile.translation
		tile.previous = null
		tile.distance = 999
		tile.terrain = r_tile.terrain
		output[tile.position] = tile
	return output
