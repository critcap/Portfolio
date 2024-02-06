class_name SelectMenuState
extends BattleState

var menu: SelectionMenuController


func enter():
	menu = owner.selection_menu
	.enter()


func exit():
	.exit()
	#yield(get_tree(),"idle_frame")
	menu.close()


func connect_signals() -> void:
	menu.connect("item_selected", self, "on_command_selected")


func on_command_selected(_selection) -> void:
	pass
