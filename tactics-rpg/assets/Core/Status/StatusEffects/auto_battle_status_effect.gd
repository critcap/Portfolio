class_name AutoBattleStatusEffect
extends StatusEffect

var driver: Driver


func _init(_driver: Driver) -> void:
	driver = _driver


func _ready() -> void:
	driver.owner.get_node("Status").connect("status_removed", self, "on_remove")
	driver._special = Drivers.COMPUTER


func on_remove(status: StatusEffect) -> void:
	if status == self:
		driver._special = Drivers.NONE
