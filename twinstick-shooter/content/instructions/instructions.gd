extends Node

@export var main: Node
@export var menu: CanvasLayer

func _ready():
	main.process_mode = Node.PROCESS_MODE_DISABLED

func _unhandled_input(event):
	if menu && menu.visible && event.is_action_pressed("ui_accept"):
		menu.visible = false
		main.process_mode =Node.PROCESS_MODE_INHERIT
	if menu && !menu.visible && event.is_action_pressed("ui_cancel"):
		menu.visible = true
		main.process_mode = Node.PROCESS_MODE_DISABLED
