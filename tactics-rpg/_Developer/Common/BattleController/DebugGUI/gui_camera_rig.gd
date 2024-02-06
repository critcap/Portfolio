extends Node


func _gui(delta):
	GUI.label(str("Camera Rotation Y: ", owner.camera_rig.rotation_degrees.y))
