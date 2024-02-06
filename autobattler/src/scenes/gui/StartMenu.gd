extends Control

onready var btn_continue = $Control/MarginContainer/VBoxContainer/Button
onready var btn_restart = $Control/MarginContainer/VBoxContainer/Button2
onready var btn_exit = $Control/MarginContainer/VBoxContainer/Button3

func open() -> void:
	visible = true
	$AnimationPlayer.play("open")
	grab_focus()
	yield($AnimationPlayer, "animation_finished")
	
	
func close() -> void:
	release_focus()
	$AnimationPlayer.play_backwards("open")
	yield($AnimationPlayer, "animation_finished")
	visible = false
	

func _gui_input(event: InputEvent) -> void:
	if visible && !$AnimationPlayer.is_playing():
		if event.is_action_pressed("ui_cancel"):	
			accept_event()
			close()
		if event is InputEventMouseButton:
			accept_event()
			close()
	
