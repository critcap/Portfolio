class_name ActiveInputLabel
extends Label

var index := 0

onready var progress_indicator := $ColorRect


func set_text(value) -> void:
	_on_TypingTest_word_passed()
	.set_text(value)


func _on_TypingTest_correct_letter_input(_code: int):
	progress_indicator.color = PlayerManager.settings.correct_input_color
	index += 1
	update_progress_indicator()


func _on_TypingTest_wrong_letter_input(_code: int):
	progress_indicator.color = PlayerManager.settings.false_input_color
	update_progress_indicator(1)


func _on_TypingTest_word_passed():
	index = 0
	progress_indicator.rect_size.x = 0
	text = ""


func get_current() -> String:
	return text


func update_progress_indicator(offset: int = 0):
	if get_current().empty():
		progress_indicator.rect_size.x = 0
		return
	progress_indicator.rect_size.x = rect_size.x / get_current().length() * (index + offset)


func _on_Label_visibility_changed():
	index = 0
	progress_indicator.rect_size.x = 0
