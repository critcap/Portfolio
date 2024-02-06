class_name TestState
extends State

var can_reload: bool = false
var can_quit: bool = false


# wrapper method for changing states
func change_state(state: String) -> void:
	if owner == null || !owner.has_method("change_state"):
		print("Error owner cannot change state")

	yield(get_tree(), "idle_frame")
	owner.change_state(state)


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reload_test") && can_reload:
		on_reload_test()
		return
	if event.is_action_pressed("quit_test") && can_quit:
		on_quit_test()
		return
	if event.is_action_pressed("show_help"):
		owner.ui_help.visible = !owner.ui_help.visible
		return


func on_reload_test() -> void:
	if owner == null:
		return
	owner.stats_collector.reset()
	owner.typing_test.is_reload = true
	change_state("SetupTestState")
	can_reload = false
	can_quit = false


func on_quit_test() -> void:
	if owner == null:
		return
	var test = owner.typing_test
	owner.remove_child(test)
	test.queue_free()
	#var validator = owner.validator
	#owner.remove_child(validator)
	owner.stats_collector.reset()
	change_state("SelectTestState")
	can_reload = false
	can_quit = false
