extends Label

@export var body: CharacterBody2D

func _process(delta):
	if !body:
		return
	text = str("Velocity", body.velocity, "|", body.velocity.length())
	
