extends Node2D


var timer: float = 0.0
var active: bool = false;

func _ready():
	$PlayerCharacterBase/CharacterController.Character = %PlayerCharacterBase

func _unhandled_input(event):
	if event.is_action_pressed("debug_close"):
		get_tree().quit()
	if event.is_action_pressed("debug_reload"):
		$"%PlayerCharacterBase".global_position = Vector2.ZERO


func _process(delta):
	if !active:
		return
	timer += delta


func _input(event):
	if !event.is_action_pressed("ui_accept"):
		return
	
	if active:
		active = false
		return
	
	timer = 0.0
	active = true
	
