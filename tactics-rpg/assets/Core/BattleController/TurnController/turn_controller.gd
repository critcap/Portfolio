class_name TurnController
extends Node

signal turn_has_began(units)
signal turn_has_ended(units)

const DEFAULT_COST := 1000
const TURN_CHECK_NOTIFICATION: = "turn_check_notification"
const TURN_START_NOTIFICATION: = "turn_start_notification"
const TURN_END_NOTIFICATION: = "turn_end_notification"

var turn: Turn

var _turn_state: GDScriptFunctionState


func advance_turn() -> void:
	if !_turn_state:
		_turn_state = _process_turn()
		return

	_turn_state = _turn_state.resume()


func _process_turn() -> void:
	var units := owner.units as Array

	while true:
		for unit in units:
			if !unit.has_node("Stats") || !unit.get_node("Health").is_alive():
				continue
			
			var stats = unit.get_node("Stats")
			# decrements but could also be incremental, bound to change
			var spd = stats.get_value(StatTypes.SPD)
			var wait = stats.get_value(StatTypes.WAIT)
			stats.set_value(StatTypes.WAIT, wait - spd)

		units.sort_custom(self, "sort_wait_time")

		for battler in units:
			if can_take_turn(battler):
				_change_turn()
				emit_signal("turn_has_began", units.duplicate())
				turn.subject = battler
				Notifications.call_subscribtion(TURN_START_NOTIFICATION, turn, self)
				yield()

				battler.get_node("Stats").set_value(StatTypes.WAIT, DEFAULT_COST)
				emit_signal("turn_has_ended", units.duplicate())
				Notifications.call_subscribtion(TURN_END_NOTIFICATION, turn, self)
				yield()


func _change_turn() -> void:
	if turn:
		if !turn.stack.empty():
			for c in turn.stack:
				c.queue_free()
		if turn.sequence:
			turn.sequence.free()
		turn.free()
	turn = Turn.new()
	add_child(turn)


static func can_take_turn(battler: Node) -> bool:
	if !battler.has_node("Stats"):
		return false

	if get_wait_counter(battler) > 0:
		return false

	return true


static func get_wait_counter(unit: Node) -> int:
	return unit.get_node("Stats").get_value(StatTypes.WAIT)


static func sort_wait_time(a, b) -> bool:
	if get_wait_counter(a) < get_wait_counter(b):
		return true
	# elif get_wait_counter(a) == get_wait_counter(b):
	# 	if a.get_instance_id() < b.get_instance_id():
	# 		return true
	return false
