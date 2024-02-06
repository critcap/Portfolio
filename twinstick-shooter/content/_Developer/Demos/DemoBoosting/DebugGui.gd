extends Node

@export var base: Node2D

func _gui(delta):
	if !base:
		return
		
	base.MaxDistance = Gui.hslide(base.MaxDistance, 0, 9999)
	Gui.progress(80.0)
