# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
class_name PointAbilityAreaTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://assets/Core/Ability/Area/point_ability_area.gd'

var board
var ability
var area

func before():
	board = auto_free(Board.new())
	board._tiles = BoardGenerator.generate_board(Vector2(10, 10))
	ability = auto_free(Ability.new())
	area = auto_free(PointAbilityArea.new())
	ability.add_child(auto_free(AreaAbilityRange.new()))
	ability.add_child(area)
	ability.ability_range.horizontal = 5
	ability.ability_range.vertical = 2
	ability.ability_range.pawn = auto_free(Actor.new())
	ability.ability_range.pawn.place(board.get_tile(Vector3.ZERO))


func test_get_tiles_in_area() -> void:
	var point = Vector3(2,0,4)
	var tiles = area.get_tiles_in_area(board, point)
	assert_object(tiles[0]).is_equal(board.get_tile(point))
