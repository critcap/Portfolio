class_name PerformAbilityState
extends BattleState


func enter():
	.enter()
	var stats = self.subject.get_node("Stats")
	stats.set_value(StatTypes.ATP, stats.get_value(StatTypes.ATP) - 1)
	play_animation()
	

func perform():
	self.ability.perform(self.turn.targets)
	yield(get_tree(), "idle_frame")
	if is_battle_over():
		process_battle_end()
		return
	owner.change_state("SelectCommandState")


func play_animation() -> void:
	var animation = get_ability_animation()
	if animation == null:
		perform()
		return
	animation.play()
	yield(animation, "animation_finished")
	perform()
	
	
func get_ability_animation() -> AbilityAnimation:
	for c in self.ability.get_children():
		if c is AbilityAnimation:
			return c
	return null
