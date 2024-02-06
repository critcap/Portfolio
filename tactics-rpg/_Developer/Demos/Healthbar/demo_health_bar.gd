extends Node

var unit: Node


func _ready():
	unit = UnitFactory.create_unit()
	var health = unit.get_node("Health")
	$HealthBar.setup(health)


func _gui(_delta) -> void:
	var health = unit.get_node("Health")
	health.maxhp = GUI.spin(health.maxhp,0, 999)
	health.current = GUI.spin(health.current,0, health.maxhp)
	
