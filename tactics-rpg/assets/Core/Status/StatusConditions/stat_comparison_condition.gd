class_name StatComparisonCondition
extends StatusCondition

var type: int
var value: int
var stats: Stats
var operator: FuncRef

func _init(_stats: Stats, _type: int, _value: int, _operator: FuncRef = null):
	type = _type
	value = _value
	stats = _stats
	operator = _operator

	stats.connect("stat_has_changed", self, "on_stat_has_changed")


func on_stat_has_changed(_type: int, _value: int) -> void:
	if _type != type:
		return
	
	if operator != null && !operator.call_func():
		remove()

#region operator functions
func equal_to() -> bool:
	return stats.get_value(type) == value


func lesser_that() -> bool:
	return stats.get_value(type) < value


func greatern_tham() -> bool:
	return stats.get_value(type) > value
#endregion