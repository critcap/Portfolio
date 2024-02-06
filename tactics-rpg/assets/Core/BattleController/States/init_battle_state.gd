class_name InitBattleState
extends BattleState

const UNIT_COUNT = 8


func enter() -> void:
	.enter()
	setup_battle_controller()
	spawn_units_at_random()
	owner.victory_condition.setup()

	var tc = owner.get_node("TurnController") as TurnController
	var td = owner.get_node("TurnOrderDisplay")
	tc.connect("turn_has_began", td, "refresh")
	tc.connect("turn_has_ended", td, "refresh")
	td.setup(owner.units)
	owner.get_node("StatusDisplay").units = owner.units

	yield(get_tree(), "idle_frame")
	owner.change_state("StartTurnState")


func setup_battle_controller() -> void:
	owner.camera_rig = owner.get_node("CameraRig") as CameraRigController
	owner.board = owner.get_node("Board") as Board
	owner.cursor = owner.get_node("CursorController") as CursorController
	owner.cursor.board = owner.board
	owner.cursor.position = Vector3.ZERO
	owner.selection_menu = owner.get_node("SelectionMenu") as SelectionMenuController
	owner.cpu = owner.get_node("ComputerPlayer")
	owner.cursor.connect("tile_changed", owner.get_node("Control"), "on_cursor_position_changed")
	

func spawn_units_at_random() -> void:
	var rng = RandomNumberGenerator.new()
	var occupied = []
	var tiles = filter_water_tiles()
	var board_size = tiles.size()

	for faction in [Factions.HERO, Factions.ENEMY]:
		for i in int(UNIT_COUNT / 2.0):
			var unit = UnitFactory.create_unit(faction)
			owner.get_node("Battlers").add_child(unit)
			unit.name += " " + str(i + 1)
			rng.randomize()
			while true:
				var pick = rng.randi_range(0, board_size - 1)

				var tile = tiles[pick]
				if occupied.has(tile):
					continue

				occupied.append(tile)

				var pawn = unit.get_node("Pawn")
				pawn.place(tile)
				pawn.match_tile()
				pawn.direction = rng.randi_range(0, 3)
				break


func filter_water_tiles() -> Array:
	var filtered: = []
	for tile in self.board._tiles.values():
		if tile.terrain == Terrain.WATER:
			continue
		filtered.append(tile)
	return filtered
