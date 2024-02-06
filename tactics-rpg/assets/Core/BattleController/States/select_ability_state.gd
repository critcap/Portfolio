class_name SelectAbilityState
extends SelectMenuState

var menu_items: Dictionary


func enter() -> void:
	.enter()
	menu_items = {}
	for ability in self.subject.get_node("Abilities").get_all_abilities():
		menu_items[ability.name] = ability
		
	menu.create_menu_list(menu_items.keys())
	menu.open(owner.camera_rig.camera.unproject_position(owner.tile.translation))


func on_cancel() -> void:
	yield(get_tree(), "idle_frame")
	self.turn.ability = null
	owner.change_state("SelectCommandState")
	

func on_command_selected(selection) -> void:
	if !menu_items.has(selection):
		return
	
	self.turn.ability = menu_items[selection]
	owner.change_state("SelectTargetState")
