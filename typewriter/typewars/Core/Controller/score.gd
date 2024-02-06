class_name Score
extends Node

# region Properties

signal score_changed(score)
signal multiplier_changed(multiplier)

export(int, 1, 9999, 1) var score_value := 100
export(bool) var refresh_second_chance := true

var score: int setget , get_score
var multiplier: int setget , get_multiplier
var second_chance: bool setget , get_second_chance

# Score without multiplier applied
var _base_score: int
# Score including multiplied value
var _score: int setget _set_score
# Increments on word pass and resets on wrong letter input
var _multiplier: int setget _set_multiplier
# Prevents loss of multiplier on first wrong input. Refreshes on correct word input
var _second_chance: bool

# endregion

# region Setters & Getters


func get_score() -> int:
	return _score


func get_multiplier() -> int:
	return _multiplier


func get_second_chance() -> bool:
	return _second_chance


func _set_score(value: int) -> void:
	_score = value
	emit_signal("score_changed", _score)


func _set_multiplier(value: int) -> void:
	_multiplier = value
	emit_signal("multiplier_changed", _multiplier)


# endregion

# region EventHandlers


func on_correct_letter_input(_code: int) -> void:
	_base_score += score_value
	self._score += score_value * _multiplier


func on_wrong_letter_input(_code: int) -> void:
	if !_second_chance:
		_second_chance = false
		self._multiplier = 0

	_base_score -= 100
	self._score += (score_value * _multiplier) * -1


func on_word_passed() -> void:
	self._multiplier += 1
	if refresh_second_chance:
		_second_chance = true

# endregion
