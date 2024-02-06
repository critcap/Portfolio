class_name Stopwatch
extends Node

var _paused

var _stopped
var _current: int
var _total


func start() -> void:
	_paused = false
	_stopped = false
	_current = OS.get_ticks_msec()
	_total = 0


func pause() -> void:
	if !_stopped || _paused:
		return
	_paused = true
	_current = OS.get_ticks_msec() - _current


func resume() -> void:
	if !_stopped || !_paused:
		return
	_paused = false
	_total += _current
	_current = OS.get_ticks_msec()


func stop() -> void:
	_stopped = true
	_current = OS.get_ticks_msec() - _current


func get_time() -> float:
	return float(_total + _current) / 1000


func get_current_time() -> float:
	return -1 * float(_current - OS.get_ticks_msec()) / 1000


func has_started() -> bool:
	return _current != 0
