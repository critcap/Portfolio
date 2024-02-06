extends MarginContainer

const BASE_COLOR = Color(1,1,1,1)
export (Color) var death_color: Color

onready var _health = $CenterContainer/VBoxContainer/HealthBar
onready var _icon = $CenterContainer/VBoxContainer/CenterContainer/TextureRect


func setup(unit: Node) -> void:
	var health = unit.get_node("Health")
	if !health:
		return
	
	_health.setup(health)
	health.connect("current_hp_changed", self, "on_current_health_changed")
	
func on_current_health_changed(value):
	if value <= 0:
		_icon.modulate = death_color
		return
	_icon.modulate = BASE_COLOR
