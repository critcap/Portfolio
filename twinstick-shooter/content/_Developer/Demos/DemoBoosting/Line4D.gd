extends Line2D

@export var character: CharacterBody2D
@export var length: int = 100

func _physics_process(delta):
	if !character:
		return
	var velocity: Vector2 = character.velocity
	clear_points()
	add_point(Vector2.ZERO)
	add_point(velocity/4)
	
