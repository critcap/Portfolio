class_name InputPrompt
extends Control

var content: Array

# ui elements
onready var ui_active: ActiveInputLabel = $CenterContainer/MarginContainer/ActivePromptLabel
onready var ui_queue: InputPromptQueue = $InputPromptQueue
onready var ui_completed: InputPromptCompleted = $InputPromptCompleted


func bind_validator(validator: Validator):
	validator.connect("word_passed", self, "on_word_passed")
	# ui_active binds
	validator.connect("wrong_letter_input", ui_active, "_on_TypingTest_wrong_letter_input")
	validator.connect("correct_letter_input", ui_active, "_on_TypingTest_correct_letter_input")
#	validator.connect("word_passed", ui_active, "_on_TypingTest_word_passed")
	pass


func setup_test(test: TypingTest):
	reset()
	content = Array(test.content)
	ui_active.text = content.pop_front()
	ui_queue.add_queue(content)
	ui_active.visible = true
	ui_completed.visible = true
	ui_queue.visible = true


func on_word_passed():
	var finished: String = ui_active.text
	var next: String = get_next_word()
	if next == null || next.empty():
		return
	ui_active.set_text(next)
	ui_completed.push(finished)


func get_next_word() -> String:
	var next_word: Label = ui_queue.pop()
	if next_word == null || next_word.text.empty():
		return ""
	return next_word.text


func reset():
	ui_active._on_TypingTest_word_passed()
	ui_queue.reset()
	ui_completed.reset()
