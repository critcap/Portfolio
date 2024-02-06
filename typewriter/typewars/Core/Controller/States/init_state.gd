class_name InitState
extends TestState

# TODO change to config or cache last used user
const TESTS = {
	"homerow":
	{
		"content": KeyboardRows.HOMEROW,
		"args": {"combine": ["toprow", "bottomrow"], "mode": 1, "size": 50}
	},
	"toprow": {"content": KeyboardRows.TOPROW, "args": {"combine": ["homerow", "bottomrow"]}},
	"bottomrow":
	{
		"content": KeyboardRows.BOTTOMROW,
		"args": {"combine": ["toprow", "homerow"], "mode": 1, "size": 50}
	},
	"brown_fox":
	{"content": "The quick brown fox jumps over the lazy dog", "args": {"mode": 1, "size": 5}},
	"common_german": {"content": CommonWords.GERMAN, "args": {"mode": 1, "size": 60}},
	"common_english": {"content": CommonWords.ENGLISH, "args": {"mode": 1, "size": 60}},
}


func enter() -> void:
	.enter()
	init_members()
	init_test_list()
	change_state("SelectTestState")


func init_members() -> void:
	# Setup members
	owner.stats_collector = TypingStatsCollector.new()
	owner.add_child(owner.stats_collector)
	owner.validator = Validator.new()
	owner.add_child(owner.validator)

	# region connecting signals
	var collector := owner.stats_collector as TypingStatsCollector
	owner.validator.connect("correct_letter_input", collector, "on_correct_letter_pressed")
	owner.validator.connect("wrong_letter_input", collector, "on_wrong_letter_pressed")
	owner.validator.connect("word_passed", collector, "on_word_passed")
	# connect to prompt display
	owner.ui_prompt.bind_validator(owner.validator)


#	var prompt = owner.ui_prompt.prompt_display
#	owner.validator.connect("correct_letter_input", prompt, "_on_TypingTest_correct_letter_input")
#	owner.validator.connect("wrong_letter_input", prompt, "_on_TypingTest_wrong_letter_input")
#	owner.validator.connect("word_passed", prompt, "_on_TypingTest_word_passed")
# endregion


func init_test_list() -> void:
	var tests = {}
	for key in TESTS.keys():
		var test = TypingTestData.new()
		test.name = key
		test.data = TESTS[key]["content"] if TESTS[key].has("content") else ""
		test.arguments = TESTS[key]["args"] if TESTS[key].has("args") else {}
		tests[key] = test
	owner.test_list = tests
