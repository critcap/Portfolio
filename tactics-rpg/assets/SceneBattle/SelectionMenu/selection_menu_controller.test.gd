extends Node

const COMMANDS = ["Attack", "Move", "Items"]


# Called when the node enters the scene tree for the first time.
func _ready():
	owner.connect("item_selected", self, "on_item_selected")
	owner.create_menu_list(COMMANDS)
	owner._items[0].emit_signal("pressed")


func _on_item_selected(item) -> void:
	print(item)
