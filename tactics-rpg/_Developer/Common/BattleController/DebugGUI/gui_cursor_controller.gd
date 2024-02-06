extends Node


func _gui(_delta):
	if owner.cursor:
		GUI.label(str("Cursor Position: ", owner.cursor.position))
		GUI.label(str("Cursor Index: ", owner.cursor.index))
