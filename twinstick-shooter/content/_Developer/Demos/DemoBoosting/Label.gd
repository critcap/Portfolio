extends Label

@export var character: CharacterBody2D


func _process(delta):
	if !character: 
		return
		
	text= str(character.global_position)
