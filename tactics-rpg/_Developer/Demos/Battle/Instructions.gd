extends Node





# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _unhandled_input(event):
	if $ColorRect.visible:
		get_viewport().set_input_as_handled()
	if $ColorRect.visible && event.is_action_pressed("ui_accept"):
		$ColorRect.visible = false
		get_viewport().set_input_as_handled()
	if !$ColorRect.visible && event.is_action_pressed("ui_cancel"):
		$ColorRect.visible = true
		get_viewport().set_input_as_handled()
