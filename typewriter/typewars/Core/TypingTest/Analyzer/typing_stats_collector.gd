class_name TypingStatsCollector
extends Node

var data: Dictionary setget , get_data
var words: int setget , get_words
var time: int

var _data := {}
var _words: int
var _time_stamp: int


# region Setters & Getters
func get_data() -> Dictionary:
	return _data.duplicate()


func get_words() -> int:
	return _words


func reset() -> void:
	_data = {}
	_words = 0
	_time_stamp = OS.get_ticks_msec()


# endregion


# region Public methods
func on_correct_letter_pressed(code: int) -> void:
	if not _data.has(code):
		_add_new_entry(code)

	var letter := _data[code] as Dictionary
	letter[ETypingStats.TOTAL_COUNT] += 1
	letter[ETypingStats.CORRECT] += 1
	var input_delta = _get_time_stamp()
	letter[ETypingStats.TOTAL_TIME] += input_delta

	if letter[ETypingStats.TOTAL_COUNT] == 1:
		letter[ETypingStats.FASTEST] = letter[ETypingStats.TOTAL_TIME]
		letter[ETypingStats.LONGEST] = letter[ETypingStats.TOTAL_TIME]
	else:
		letter[ETypingStats.FASTEST] = min(letter[ETypingStats.FASTEST], input_delta)
		letter[ETypingStats.LONGEST] = max(letter[ETypingStats.LONGEST], input_delta)


func on_wrong_letter_pressed(code: int) -> void:
	if not _data.has(code):
		_add_new_entry(code)

	var letter := _data[code] as Dictionary
	letter[ETypingStats.TOTAL_COUNT] += 1
	letter[ETypingStats.ERRORS] += 1


func on_word_passed() -> void:
	_words += 1


# endregion


# region Private methods
func _add_new_entry(code: int) -> void:
	_data[code] = {
		ETypingStats.CODE: code,
		ETypingStats.TOTAL_COUNT: 0,
		ETypingStats.TOTAL_TIME: 0,
		ETypingStats.CORRECT: 0,
		ETypingStats.ERRORS: 0,
		ETypingStats.FASTEST: 0,
		ETypingStats.LONGEST: 0
	}


func _get_time_stamp(get_time_only: bool = false) -> int:
	if !_time_stamp:
		_time_stamp = OS.get_ticks_msec()
		return 0

	var stamp = OS.get_ticks_msec()
	var time_stamp = stamp - _time_stamp
	if !get_time_only:
		_time_stamp = stamp
	return time_stamp
# endregion
