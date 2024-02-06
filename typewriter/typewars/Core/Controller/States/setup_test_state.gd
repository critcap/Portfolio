class_name SetupTestState
extends TestState

var prompt


func enter() -> void:
	.enter()
#	prompt = owner.ui_prompt.prompt_display
	if owner.typing_test.is_reload:
		reload_test()
	# only automatically shows help window on the first test of current user
	owner.ui_help.visible = PlayerManager.results.empty()
	setup_test()


func setup_test() -> void:
	# setup test classes
	# adds scancodes to the validator
	var test := owner.typing_test as TypingTest
	var validator = owner.validator
	validator.setup(test.scancodes)

	# ui setup
	owner.ui_prompt.setup_test(test)

	if test.mode == TypingTestModes.RACE:
		change_state("TypeRaceTestState")
		return
	elif test.mode == TypingTestModes.TIME_ATTACK:
		change_state("TimeAttackTestState")
		return


func reload_test() -> void:
	var old_test := owner.typing_test as TypingTest
	var test_data := owner.test_list[old_test.name] as TypingTestData
	var test_list := owner.test_list as Dictionary
	var args = old_test.arguments.duplicate()
	owner.remove_child(old_test)
	old_test.free()
	var test := TypingTestFactory.assemble_test(test_data, args, test_list)
	test.scancodes = ScancodeConverter.convert_text_to_scancodes(test.content)
	owner.typing_test = test
	owner.add_child(test)
