extends Control

var tile: Tile
var has_content: bool setget , has_content


func has_content() -> bool:
	return tile.content != null


func _gui(_delta) -> void:
	if tile:
		GUI.label("TARGET SELECTION")
		GUI.label(str("Tile: ", tile.position, " Content: ", self.has_content()))
