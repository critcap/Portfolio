class_name SelectCommandState
extends SelectMenuState

# TODO
const COMMANDS = ["Move", "Attack", "Select Ability", "End Turn", "Auto Battle"]

func enter() -> void:
	.enter()
	if is_ai_turn():
		yield(get_tree(), "idle_frame")
		if can_move():
			if self.turn.sequence.move_location != null \
				|| self.turn.sequence.move_location == self.subject.get_node("Pawn").tile:
				move_to_movement_state()
				return
				
		if self.turn.sequence.ability != null && can_act():
			move_to_ability_selection(self.turn.sequence.ability.name)
			return
		owner.change_state("SelectFacingState")	

	if can_act() || can_move():
		menu.create_menu_list(COMMANDS)
		menu.open(owner.camera_rig.camera.unproject_position(owner.tile.translation))

	else:
		yield(get_tree(), "idle_frame")
		owner.change_state("SelectFacingState")


func on_command_selected(command) -> void:
	match command:
		"Move":
			move_to_movement_state()
		"Attack", "Select Ability":
			move_to_ability_selection(command)
		"End Turn":
			owner.change_state("SelectFacingState")
		"Auto Battle":
			auto_battle()
		_:
			print("Command not defined!")


func move_to_movement_state() -> void:
	if self.subject.get_node("Stats").get_value(StatTypes.MVP) <= 0:
		return

	self.turn.add_command(MoveCommand.new())
	owner.change_state("SelectMovementState")


func move_to_ability_selection(ability_name: String = "") -> void:
	if self.subject.get_node("Stats").get_value(StatTypes.ATP) <= 0:
		return

	self.turn.ability = self.subject.get_node("Abilities").get_ability(ability_name)
	
	if self.turn.ability:
		owner.change_state("SelectTargetState")
		return
		
	owner.change_state("SelectAbilityState")


func can_move() -> bool:
	return self.subject.get_node("Stats").get_value(StatTypes.MVP) > 0


func can_act() -> bool:
	return self.subject.get_node("Stats").get_value(StatTypes.ATP) > 0


func auto_battle():
	var auto_battler = AutoBattleStatusEffect.new(self.subject.get_node("Driver"))
	var condition = DurationStatusCondition.new(1, TurnController.TURN_END_NOTIFICATION)
	self.subject.get_node("Status").add(auto_battler, condition)
	owner.turn.sequence = owner.cpu.evaluate()
	self.exit()
	self.enter()
