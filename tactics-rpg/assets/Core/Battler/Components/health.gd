class_name Health
extends Node

const HP_CHANGE_NOTIFICATION = "current_hp_changed"

signal current_hp_changed(new_chp)
signal max_hp_changed(new_mhp)
signal check_is_alive(expcetion)


#region puplic properties
var current: int setget set_current_hp, get_current_hp
var maxhp: int setget set_max_hp, get_max_hp
var minhp := 0
#endregion

var _stats: Stats setget _set_stats


#region setget
func set_current_hp(value: int) -> void:
	_stats.set_value(StatTypes.HP, int(clamp(value, self.minhp, self.maxhp)))


func get_current_hp() -> int:
	return _stats.get_value(StatTypes.HP)


func set_max_hp(value: int) -> void:
	_stats.set_value(StatTypes.MHP, value)


func get_max_hp() -> int:
	return _stats.get_value(StatTypes.MHP)


func is_alive() -> bool:
	var checker = BaseException.new(true)
	emit_signal("check_is_alive", checker)
	return checker.toggle

#endregion


func _set_stats(value: Stats) -> void:
	_stats = value
	_stats.connect("stat_has_changed", self, "on_stat_has_changed")


func on_stat_has_changed(type: int, value: int) -> void:
	if type == StatTypes.HP:
		emit_signal("current_hp_changed", self.current)
		Notifications.call_subscribtion(HP_CHANGE_NOTIFICATION, self)
	if type == StatTypes.MHP:
		if maxhp > value:
			self.hp = clamp(self.hp, minhp, value)
		emit_signal("max_hp_changed", self.maxhp)


static func sort_current_health(a, b) -> bool:
	a = a.get_node("Health").current
	b = b.get_node("Health").current
	if a < b:
		return true
	return false
	
