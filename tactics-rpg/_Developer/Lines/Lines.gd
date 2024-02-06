extends Node

var tiles: Array = []
var _show_compass: bool = true
var index: int = 0

onready var ability_range = $RangeAttack.ability_range
onready var projectile = $RangeAttack.find_node("Projectile", true, false)
onready var actor = $Battler/Pawn


# Called when the node enters the scene tree for the first time.
func _ready():
	$Board._tiles = BoardGenerator.generate_board(Vector2(20, 20))
	$CursorController.board = $Board
	ability_range.pawn = actor

	actor.place($Board.get_tile(Vector3(0, 0, 0)))
	actor.match_tile()
	$CursorController.connect("tile_changed", self, "update_trajectory")
	
	$RangeAttack.subject = $"Battler"


func _gui(_delta) -> void:
	if GUI.button("Show Compass"):
		_show_compass = !_show_compass

	ability_range.horizontal = GUI.spin(
		7, ability_range.min_horizontal + 1, 999
	)
	ability_range.min_horizontal = GUI.spin(
		3, 0, ability_range.horizontal - 1
	)
	if GUI.button("Refresh Range"):
		draw_ability_range()
	


func draw_ability_range() -> void:
	$Board.deselect_tiles()
	tiles = ability_range.get_tiles_in_range($Board)
	$Board.select_tiles(tiles)


func update_trajectory(tile: Tile) -> void:
	if tiles.empty() || !tiles.has(tile):
		return
	
	var start = actor.get_node("AbilityAnchor").global_transform.origin
	var end = tile.translation
	var height = end / 2
	height.y = calculate_arc_zenith(end, start, ability_range)
	$LineRenderer.points.clear()
	for t in range(0, 10 + 1, 1):
		var point = quadratic_bezier(start, height, end, float(t) / 10)
		$LineRenderer.points.append(point)
	
	$Triangle.points.clear()
	if _show_compass:
		draw_compass(start, height, end)
	print(yield(projectile.check_projectile_hit(tile), "completed"))


func quadratic_bezier(p0: Vector3, p1: Vector3, p2: Vector3, t) -> Vector3:
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	return q0.linear_interpolate(q1, t)


func draw_compass(start, height, end) -> void:
	$Triangle.points.clear()
	$Triangle.points.append(start)
	$Triangle.points.append(height)
	$Triangle.points.append(end)


func calculate_arc_zenith(tile: Vector3, actor: Vector3, r: AbilityRange) -> float:
	var difference = (tile - actor).abs()
	difference = difference[difference.max_axis()]
	difference = clamp(difference - r.min_horizontal, 0, 99)
	var scale := float(r.min_horizontal) / float(r.horizontal)
	return r.horizontal - (difference) * scale
