extends Node

@onready var player = $"../Field/PlayerCharacterBase"
var state_name: String = ""

func _gui(delta):
	if !player:
		return
	
	Gui.label(str(player.velocity, " ", player.velocity.length()))
	Gui.label(state_name)

func _on_character_controller_state_changed(state):
	state_name = state.name
