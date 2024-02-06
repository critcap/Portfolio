class_name BattleState
extends State

var camera_rig: CameraRigController setget , get_camera_rig
var board setget , get_board
var tile setget , get_tile
var subject setget , get_subject
var command setget , get_command
var turn setget , get_turn
var ability setget set_ability, get_ability

func get_command() -> Command:
	return owner.turn.command

func get_tile() -> Tile:
	return owner.tile


func get_camera_rig() -> CameraRigController:
	return owner.camera_rig


func get_board() -> Node:
	return owner.board


func get_subject() -> Node:
	if owner.turn:
		return owner.turn.subject
	return null


func get_turn() -> Turn:
	return owner.turn


func set_ability(_ability: Ability) -> void:
	self.turn.ability = _ability

	
func get_ability() -> Ability:
	if self.turn:
		return self.turn.ability
	return null


func disconnect_signals() -> void:
	var all_signals = get_incoming_connections()

	if all_signals.size() < 1:
		return

	for s in all_signals:
		s.source.disconnect(s.signal_name, self, s.method_name)


func unhandled_input(event) -> void:
	if is_ai_turn():
		return
		
	if event.is_action_pressed("ui_accept"):
		on_accept()

	elif event.is_action_pressed("ui_cancel"):
		on_cancel()

		
func is_ai_turn() -> bool:
	if !owner.turn:
		return false
	if owner.subject:
		return owner.subject.get_node("Driver").current == Drivers.COMPUTER
	return false
	
	
# virtual function
func on_accept() -> void:
	pass


func on_cancel() -> void:
	pass


func did_player_win() -> bool:
	return owner.victory_condition.victor == Factions.HERO


func is_battle_over() -> bool:
	return owner.victory_condition.victor != Factions.NONE


func process_battle_end() -> void:
	if !is_battle_over():
		return
	
	yield(get_tree(), "idle_frame")
	owner.change_state("EndOfBattleState")
