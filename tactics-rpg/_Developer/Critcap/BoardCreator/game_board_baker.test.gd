extends GdUnitTestSuite

const __source = "res://Critcap/BoardCreator/BoardBaker/game_board_baker.gd"

var baker: BoardEditorBaker
var cached_editor_cells: PoolVector3Array = []


func before():
	baker = BoardEditorBaker.new()
	baker.cell_size = Vector3(1, 1, 1)
	baker.mesh_library = load("res://Critcap/BoardCreator/ML_BoardBaker.tres")
	for t in BoardGenerator.generate_board(Vector2(10, 10)).values():
		cached_editor_cells.append(t.position)
		t.free()


func before_test() -> void:
	baker._board_data = {}
	baker._restore_cache = {}
	if baker.get_used_cells().size() == 0:
		for item in cached_editor_cells:
			baker.set_cell_item(item.x, item.y, item.z, 0)


func test_all_tiles_are_loaded() -> void:
	assert_int(baker.get_used_cells().size()).is_equal(21 * 21)


func test_bake_board_data() -> void:
	baker.bake_board_data()
	var b_tiles = baker._board_data.tiles.values()
	assert_int(baker.get_used_cells().size()).is_equal(b_tiles.size())


func test_if_board_clears() -> void:
	baker.bake_board_data()
	baker.clear_board_data()
	assert_object(baker._board_data).is_null()
	assert_int(baker.get_used_cells().size()).is_equal(0)
