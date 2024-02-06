tool
class_name BoardEditorBaker
extends GridMap

export(String) var file_name := "default"
export(String, DIR) var file_path = "res://Critcap/BoardCreator/"

var _board_data
var _restore_cache


# generates buttons for quick interface options
func _get_tool_buttons():
	return [
		{
			call = "bake_board_data",
			text = "Bake Board Data",
		},
		{call = "clear_board_data", text = "Clear current Board Data"},
		{call = "restore_board_data", text = "Restore Board Data"},
		{call = "load_board_data", text = "Load Board Data"},
		{call = "save_board_data", text = "Save Board Data"},
	]


# Public Methods
func bake_board_data():
	if _board_data:
		cache_board_data()
	_board_data = {"tiles": {}, "size": Vector3.ZERO}
	_board_data.size = cell_size
	for cell in get_used_cells():
		var tile = {"position": Vector3.ZERO, "translation": Vector3.ZERO, "terrain": 0}
		tile.position = cell
		tile.translation = map_to_world(cell.x, cell.y, cell.z) + translation
		tile.terrain = get_tile_terrain(cell)
		_board_data.tiles[tile.position] = tile


func get_tile_terrain(cell: Vector3) -> int:
	var cell_item: int = get_cell_item(cell.x, cell.y, cell.z)		
	return Terrain.WATER if (cell_item - 1) == 0  else Terrain.GROUND
	 

func clear_board_data():
	if !_board_data:
		push_warning("No data to clear!")
		return
	cache_board_data()
	_board_data = null
	clear()


func restore_board_data():
	if _restore_cache.size() < 1:
		push_warning("No deleted data to restore!")
		return
	clear()
	_board_data = _restore_cache
	draw_board_data()


func save_board_data():
	if !_board_data:
		push_warning("No Data to save!")
		return
	var path = get_file_path()
	var save_data: BoardData
	if ResourceLoader.exists(path):
		save_data = ResourceLoader.load(path)
	else:
		save_data = BoardData.new()
	save_data.tiles = _board_data.tiles
	save_data.size = _board_data.size
	var error = ResourceSaver.save(path, save_data, 1)
	if error == 0:
		print("BoardData saved to: ", path)
	else:
		print("Could not save BoardData to: ", path, " Error Code: ", error)


func load_board_data():
	var path = get_file_path()
	if !ResourceLoader.exists(path):
		push_error("Cannot load non existing file: " + path)
		return
	if _board_data:
		cache_board_data()
	_board_data = {"tiles": {}, "size": Vector3.ZERO}
	var save_data = ResourceLoader.load(path)
	_board_data.tiles = save_data.tiles
	_board_data.size = save_data.size
	print("BoardData from ", path, " loaded")
	draw_board_data()


func cache_board_data() -> void:
	_restore_cache = _board_data


func get_file_path() -> String:
	return file_path + "/" + file_name + ".tres"


func draw_board_data() -> void:
	clear()
	for t in _board_data.tiles.values():
		var mesh_id = mesh_library.get_item_list()[0]
		t = t.position
		set_cell_item(t.x, t.y, t.z, mesh_id)
