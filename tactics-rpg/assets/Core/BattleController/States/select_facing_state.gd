class_name SelectFacingState
extends SelectMenuState

const COMMANDS = ["End Turn", "Cancel"]

onready var turn_controller = owner.get_node("TurnController")

var arrows
var pawn


func enter() -> void:
	.enter()
	pawn = self.subject.get_node("Pawn")
	arrows = pawn.get_node("DirectionArrow")
	arrows.visible = true
	owner.cursor.locked = true

	if is_ai_turn():
		owner.cpu.find_nearest_enemy()
		var nearest: Vector3 = owner.cpu.nearest_enemy.get_node("Pawn").tile.position
		nearest -= owner.subject.get_node("Pawn").tile.position
		nearest.y = 0.0
		var facing = Vector3.ZERO
		var max_axis = nearest.abs().max_axis()
		facing[max_axis] = sign(nearest[max_axis])

		yield(get_tree().create_timer(0.2), "timeout")
		pawn.direction = Directions.vec3_to_dir(facing)
		yield(get_tree().create_timer(0.2), "timeout")
		on_command_selection(COMMANDS[0])


func unhandled_input(event) -> void:
	.unhandled_input(event)
	if !menu.visible:
		if event.is_action_pressed("camera_forward") || event.is_action_pressed("ui_up"):
			pawn.direction = 2
		elif event.is_action_pressed("camera_backward") || event.is_action_pressed("ui_down"):
			pawn.direction = 0
		elif event.is_action_pressed("camera_right") || event.is_action_pressed("ui_right"):
			pawn.direction = 1
		elif event.is_action_pressed("camera_left") || event.is_action_pressed("ui_left"):
			pawn.direction = 3


func on_accept() -> void:
	if menu.visible:
		on_command_selection(COMMANDS[0])
	else:
		menu.create_menu_list(COMMANDS)
		menu.rect_position = owner.camera_rig.camera.unproject_position(owner.tile.translation)
		menu.visible = true


func on_cancel() -> void:
	if menu.visible:
		menu.visible = false
		return
	owner.change_state("SelectCommandState")
	
func exit() -> void:
	.exit()
	arrows.visible = false
	owner.cursor.locked = false
	


func on_command_selection(selection: String) -> void:
	match selection:
		"End Turn":
			turn_controller.advance_turn()
			owner.change_state("StartTurnState")
		"Cancel":
			menu.visible = false
