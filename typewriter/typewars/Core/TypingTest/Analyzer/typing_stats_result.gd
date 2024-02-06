class_name TypingStatsResult
extends Reference

# Dynamic properties
var wpm: float setget , get_wpm
var cpm: float setget , get_cpm
var accuracy: float setget , get_accuracy
var total_strokes: int setget , get_total_strokes

# Properties
var time: int
var words: int
var total_errors: int
var total_correct: int
var most_pressed_key: int
var least_pressed_key: int
var fastest_key: int
var slowest_key: int
var longest_key: int
var most_accurate_key: int
var least_accurate_key: int

var _data: Dictionary


# region Setters and Getter#
func get_wpm() -> float:
	return words * (60.0 / time) if time != 0 else 0.0


func get_cpm() -> float:
	return total_correct * (60.0 / time) if time != 0 else 0.0


func get_accuracy() -> float:
	return float(total_correct) / float(self.total_strokes)


func get_total_strokes() -> int:
	return total_correct + total_errors


# endregion


# region Public Methods
func get_character_stats(character: int):
	if !_data.has(character):
		push_error(str("Error no data for keycode: ", character))
		return
	return _data[character]

# endregion
