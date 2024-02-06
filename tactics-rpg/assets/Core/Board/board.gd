class_name Board
extends GridMap

var _tiles: Dictionary setget _set_tiles
var _tiles_search_index: Dictionary
var _board_multimesh
var _board_selection_index: Dictionary
var _selected_tiles: Dictionary


func _set_tiles(value: Dictionary) -> void:
	_tiles = value
	_tiles_search_index = {}
	# Maps the 3d grid into an 2d keys for pathfinding
	for i in _tiles.values():
		add_child(i)
		var key = Vector2(i.position.x, i.position.z)
		var has_index = _tiles_search_index.has(key)
		var index = _tiles_search_index[key] if has_index else []
		index.append(i)
		_tiles_search_index[key] = index
	setup_board_multimesh()


func get_tile(pos: Vector3) -> Object:
	return _tiles[pos] if _tiles.get(pos) else null


# TODO should be renamed when not private
func get_pf_tiles(pos: Vector3) -> Array:
	var pos_vec2 = Vector2(pos.x, pos.z)
	return _tiles_search_index[pos_vec2] if _tiles_search_index.has(pos_vec2) else []


func search_tiles(origin: Vector3, search: FuncRef) -> Array:
	clear_pathfinding()
	var dirs = [Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK]
	var output = []
	var check_now = []
	var check_next = []
	# here I use get_tile because we want a single tile and avoid the possibility to get 2
	var start = get_tile(origin)
	start.distance = 0
	output.append(start)
	check_now.append(start)

	while check_now.size() > 0:
		check_now.invert()
		var t = check_now.pop_back()
		check_now.invert()
		for d in dirs:
			var possible_tiles: Array = get_pf_tiles(t.position + d)
			if possible_tiles == null:
				continue
			for next in possible_tiles:
				if next.position == null || next.distance <= t.distance + 1:
					continue
				if search.call_func(t, next):
					next.distance = t.distance + 1
					next.previous = t
					check_next.append(next)
					output.append(next)
					continue
				
				var jump_tiles = get_pf_tiles(t.position + d * 2)
				if jump_tiles.empty():
					continue
					
				for tile in jump_tiles:
					if search.call_func(t, tile):
						if t.previous == tile:
							continue
						if tile.position.y != t.position.y:
							continue
						if next.content != null && next.position.y > (t.position.y - 2):
							continue
						tile.distance = t.distance + 1
						tile.previous = t
						check_next.append(tile)
						output.append(tile)

		if check_now.size() == 0:
			var temp = check_now
			check_now = check_next
			check_next = temp

	return output


func clear_pathfinding() -> void:
	for i in _tiles.values():
		i.distance = 999
		i.previous = null


# Selection Boilerplate
# TODO create a component and use these methods to interact with it
func setup_board_multimesh() -> void:
	_board_multimesh = MultiMeshInstance.new()
	var _mesh = PlaneMesh.new()
	_board_selection_index = {}
	_mesh.size = Vector2(0.9, 0.9)
	_mesh.material = load("res://assets/Materials/Debug/red/materials/material_005.tres") as SpatialMaterial
	if _mesh.material is SpatialMaterial:
		_mesh.material.flags_unshaded = true
	_board_multimesh.multimesh = MultiMesh.new()
	_board_multimesh.multimesh.mesh = _mesh
	_board_multimesh.cast_shadow = 0
	_board_multimesh.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	_board_multimesh.multimesh.instance_count = _tiles.size()
	for i in range(0, _tiles.size()):
		var tile = _tiles.values()[i] as Tile
		_board_selection_index[tile.position] = i
		var pos = tile.translation
		_board_multimesh.multimesh.set_instance_transform(
			i, Transform(Basis(), Vector3(pos.x, pos.y - 0.5, pos.z))
		)
	add_child(_board_multimesh)


func select_tiles(tiles: Array = []) -> void:
	if tiles.size() == 0:
		tiles = _selected_tiles.values()
	for tile in tiles:
		var index = _board_selection_index[tile.position]
		_selected_tiles[tile.position] = tile
		var pos = tile.translation
		_board_multimesh.multimesh.set_instance_transform(
			index, Transform(Basis(), Vector3(pos.x, pos.y + 0.1, pos.z))
		)


func deselect_tiles(tiles: Array = []) -> void:
	if tiles.size() == 0:
		tiles = _selected_tiles.values()
	for tile in tiles:
		var index = _board_selection_index[tile.position]
		var pos = tile.translation
		_board_multimesh.multimesh.set_instance_transform(
			index, Transform(Basis(), Vector3(pos.x, pos.y - 0.5, pos.z))
		)
		_selected_tiles.erase(tile.position)
