class_name BattleController
extends StateMachine

signal tile_changed(tile)

var camera_rig: CameraRigController
var board: Board
var cursor: CursorController
var tile: Tile setget , get_tile
var units: Array setget , get_units
var turn: CommandHistory setget , get_turn
var subject setget , get_subject
var selection_menu: SelectionMenuController
var victory_condition: BaseVictoryCondition setget , get_victory_condition
var cpu: ComputerPlayer

#region
func get_tile() -> Tile:
	emit_signal("tile_changed",board.get_tile(cursor.position))
	return board.get_tile(cursor.position) as Tile


func get_turn() -> Turn:
	return get_node("TurnController").turn


func get_units() -> Array:
	return $Battlers.get_children()


func get_victory_condition() -> BaseVictoryCondition:
	if victory_condition: 
		return victory_condition
	for child in get_children():
		if child is BaseVictoryCondition:
			victory_condition = child
			return child
	return null
	

func get_subject() -> Node:
	return self.turn.subject

#endregion

func start(init_state: String = "InitBattleState") -> void:
	change_state(init_state)
