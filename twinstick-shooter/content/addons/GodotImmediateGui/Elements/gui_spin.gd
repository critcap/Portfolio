class_name GUISpin
extends SpinBox
var base = GUIBase.new(self, "value_changed")

func _init():
	value_changed.connect(_on_value_changed)

func _on_value_changed(_value):
	get_line_edit().release_focus()
